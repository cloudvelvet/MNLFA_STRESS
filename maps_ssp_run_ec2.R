# MAPS GRM + SSP 모델 실행 (EC2 버전)
# 실행: nohup Rscript maps_ssp_run_ec2.R > run_log.txt 2>&1 &

setwd("~/chen_bauer")

library(rstan)
library(dplyr)
library(posterior)

options(mc.cores = 4)   # EC2 vCPU 수에 맞게 조정 (c6i.4xlarge → 16도 가능)
rstan_options(auto_write = TRUE)

cat("=== 시작:", as.character(Sys.time()), "===\n")

# ── 데이터 로드 ───────────────────────────────────────────────────────────────
longdat <- read.csv("longdat_maps.csv")

Nobs   <- nrow(longdat)
P      <- length(unique(longdat$item))
Ni     <- length(unique(longdat$person_id))
D      <- length(unique(longdat$time))
K      <- 5

cat("N persons:", Ni, "| Nobs:", Nobs, "| P:", P, "| D:", D, "\n")

person <- longdat$person_id
itm    <- longdat$item
time   <- longdat$time
Y      <- longdat$resp

Xtv <- as.matrix(cbind(longdat$age_c, longdat$age_sq))
Xf  <- as.matrix(longdat[, c("nat2","nat3","nat5","nat6","nat7","nat8")])

NFpreds  <- ncol(Xf)
Ntvpreds <- ncol(Xtv)

Ldf  <- matrix(1, nrow = P, ncol = NFpreds + Ntvpreds)
Mtv  <- sum(Ldf[, 1:Ntvpreds])
Mf   <- sum(Ldf[, (Ntvpreds+1):(Ntvpreds+NFpreds)])

fa.data <- list(
  Nobs = Nobs, P = P, Ni = Ni, D = D, K = K,
  person = person, itm = itm, time = time, Y = Y,
  NFpreds = NFpreds, Ntvpreds = Ntvpreds,
  Xf = Xf, Xtv = Xtv, Ldf = Ldf,
  Mtv = Mtv, Mf = Mf,
  sigma_l  = 2,
  sigma_nu = 2,
  sigma_f  = 1.5,
  sigma_di = 2,
  gamma_a  = 4000,
  gamma_b  = 200
)

init_cat <- function() {
  list(
    Lp          = runif(P, 1, 1.5),
    cutraw      = lapply(1:P, function(i) sort(runif(K-1, -2, 2))),
    lambda_l_tv = runif(1, 10, 20),
    lambda_n_tv = runif(1, 10, 20),
    lambda_l_f  = runif(1, 10, 20),
    lambda_n_f  = runif(1, 10, 20),
    L_diftv_raw = runif(Mtv,  -0.1, 0.1),
    L_diff_raw  = runif(Mf,   -0.1, 0.1),
    n_diftv_raw = runif(Mtv,  -0.1, 0.1),
    n_diff_raw  = runif(Mf,   -0.1, 0.1),
    pi_tv1      = runif(P, 0.4, 0.6),
    pi_tv2      = runif(P, 0.4, 0.6),
    pi_f        = matrix(runif(P * NFpreds, 0.4, 0.6), nrow = P),
    b_mu        = matrix(runif(2 * NFpreds, -0.05, 0.05), nrow = 2),
    b_phi       = matrix(runif(2 * NFpreds, -0.05, 0.05), nrow = 2),
    b_phicor    = runif(NFpreds, -0.1, 0.1),
    phicorr     = runif(1, -0.1, 0.1),
    mu_slp      = runif(1, 0.4, 0.6),
    phi_int     = runif(1, 0.4, 0.6),
    phi_slp     = runif(1, 0.4, 0.6),
    eti_sd2     = runif(1, -0.1, 0.1),
    fac_dist    = matrix(rnorm(2 * Ni, 0, 0.1), nrow = 2),
    fac_eti_raw = matrix(rnorm(D * Ni, 0, 0.1), nrow = D)
  )
}

cat("Stan 모델 컴파일 중...\n")
stan_m <- stan_model(file = "grm_ssp.stan", verbose = FALSE)
cat("컴파일 완료:", as.character(Sys.time()), "\n")

cat("MCMC 샘플링 시작...\n")
stan_f <- sampling(
  stan_m,
  data    = fa.data,
  pars    = c("Lp", "pi_tv1", "pi_tv2", "pi_f",
              "Ldiftv1", "Ldiftv2",
              "Ndiftv1", "Ndiftv2",
              "mu_eta", "b_mu", "b_phi",
              "phi_var1", "phi_var2", "phi_eta",
              "phicorr", "b_phicor"),
  chains  = 2,
  iter    = 500,
  warmup  = 250,
  init    = init_cat,
  cores   = 2,
  control = list(adapt_delta = 0.90, max_treedepth = 13),
  seed    = 42
)

cat("샘플링 완료:", as.character(Sys.time()), "\n")
save.image("maps_ssp_result.RData")
cat("결과 저장 완료\n")

# DIF 탐지 결과
fit_summary <- as.data.frame(
  summary(stan_f,
          pars  = c("Lp","pi_tv1","pi_tv2","pi_f","mu_eta","b_mu","phi_eta"),
          probs = c(0.025, 0.5, 0.975))$summary
)
sampler_params <- get_sampler_params(stan_f, inc_warmup = FALSE)
chain_div <- sapply(sampler_params, function(x) sum(x[, "divergent__"]))
cat("Divergences:", chain_div, "\n")
cat("Rhat > 1.1:", sum(fit_summary$Rhat > 1.1, na.rm = TRUE), "\n")

stan_draws   <- as_draws_df(stan_f)
dif_detected <- summarise_draws(
  subset_draws(stan_draws, variable = c("^pi_tv","^pi_f"), regex = TRUE)
) %>% filter(mean > 0.8)

cat("\n--- 탐지된 DIF (pi > 0.8) ---\n")
print(dif_detected, n = 50)
write.csv(dif_detected, "maps_dif_detected.csv", row.names = FALSE)
cat("=== 종료:", as.character(Sys.time()), "===\n")
