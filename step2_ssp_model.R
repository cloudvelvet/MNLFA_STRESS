# Chen & Bauer (2024) Longitudinal MNLFA
# Step 2: SSP-regularized DIF detection (1단계 — DIF 탐지)

library(Rcpp)
library(rstan)
library(tidyr)
library(dplyr)
library(data.table)

options(mc.cores = 4)
rstan_options(auto_write = TRUE)

# ── 데이터 준비 ───────────────────────────────────────────────────────────────
longdat <- read.csv("longdat.csv") %>%
  mutate(
    age2   = (age - 17.5) / 6,
    agesq  = age2^2,
    agsx   = age2 * BIO_SEX,
    ag2sx  = agesq * BIO_SEX
  )

path     <- "sspAH10"
Nobs     <- nrow(longdat)
P        <- length(unique(longdat$item))
Ni       <- length(unique(longdat$ID))
D        <- length(unique(longdat$wave))
person   <- longdat$ID
itm      <- as.numeric(longdat$item)
time     <- as.numeric(longdat$wave)

# time-varying predictors: age, age^2, age*sex, age^2*sex
Xtv      <- as.matrix(cbind(longdat$age2, longdat$agesq, longdat$agsx, longdat$ag2sx))
# time-invariant predictor: sex
Xf       <- as.matrix(longdat$BIO_SEX)

NFpreds  <- ncol(Xf)    # 1
Ntvpreds <- ncol(Xtv)   # 4
Y        <- longdat$resp

# 모든 아이템-예측변수 조합을 DIF 후보로 설정 (SSP가 자동 선택)
Ldf  <- matrix(rep(1, P * (NFpreds + Ntvpreds)), nrow = P, ncol = NFpreds + Ntvpreds)
Mtv1 <- sum(Ldf[, 1])                              # age main effect DIF
Mtv2 <- sum(Ldf[, 2:Ntvpreds])                     # age^2, age*sex, age^2*sex DIF
Mf   <- sum(Ldf[, (Ntvpreds + 1):(Ntvpreds + NFpreds)])  # sex DIF

fa.data <- list(
  Nobs = Nobs, P = P, Ni = Ni, D = D,
  person = person, itm = itm, time = time,
  NFpreds = NFpreds, Ntvpreds = Ntvpreds,
  Y = Y, Xf = Xf, Xtv = Xtv, Ldf = Ldf,
  Mtv1 = Mtv1, Mtv2 = Mtv2, Mf = Mf,
  sigma_l = 2, sigma_nu = 2, sigma_di = 2, sigma_f = 1.5,
  gamma_a = 4000, gamma_b = 200
)

init_cat <- function() {
  list(
    Lp          = runif(P,     1,   1.5),
    Np          = runif(P,    -2,  -1.5),
    L_diff      = runif(Mf,    0,    .1),
    L_diftv     = runif(Mtv1,  0,    .1),
    L_diftv2    = runif(Mtv2,  0,    .1),
    n_diff      = runif(Mf,    0,    .1),
    n_diftv     = runif(Mtv1,  0,    .1),
    n_diftv2    = runif(Mtv2,  0,    .1),
    b_mu        = matrix(runif(2 * NFpreds, 0, .05), nrow = 2),
    b_phi       = matrix(runif(2 * NFpreds, 0, .05), nrow = 2),
    b_mu_asq    = runif(1, 0, .1),
    b_mu_asqint = runif(1, 0, .1),
    mu_slp      = runif(1, .5, .51),
    phi_slp     = runif(1, .5, .51),
    phi_int     = runif(1, .5, .51)
  )
}

# ── Stan 모델 (SSP 정규화) ────────────────────────────────────────────────────
stan_m <- stan_model(file = "ssp_mnlfa.stan", verbose = FALSE)

stan_f <- sampling(
  stan_m,
  data    = fa.data,
  pars    = c("Lp","Np","Ldiff","Ldiftv","Ndiff","Ndiftv",
              "mu_eta","b_mu","b_phi","phi_var1","phi_var2",
              "phi_eta","phicorr","b_phicor",
              "lambda_lt1","lambda_lt2","lambda_lf",
              "lambda_nt1","lambda_nt2","lambda_nf",
              "pi_ff","pi_tv1","pi_tv2","pi_tv3"),
  chains  = 4,
  iter    = 3000,
  init    = init_cat,
  cores   = 4,
  control = list(adapt_delta = 0.89, max_treedepth = 13),
  seed    = 90
)

# ── 결과 저장 및 DIF 탐지 ─────────────────────────────────────────────────────
save.image("ssp1l-at.RData")

fit_summary <- as.data.frame(
  summary(stan_f,
          pars = c("Lp","Np","Ldiff","Ldiftv","Ndiff","Ndiftv",
                   "mu_eta","b_mu","b_phi","phi_var1","phi_var2",
                   "phi_eta","phicorr","b_phicor",
                   "pi_ff","pi_tv1","pi_tv2","pi_tv3"),
          probs = c(0.025, 0.5, 0.975))$summary
)

# 수렴 진단
sampler_params <- get_sampler_params(stan_f, inc_warmup = FALSE)
chain_div  <- sapply(sampler_params, function(x) sum(x[, "divergent__"]))
chain_tree <- sapply(sampler_params, function(x) max(x[, "treedepth__"]) < 13)
rhat_bad   <- sum(fit_summary$Rhat > 1.1, na.rm = TRUE)
cat("Divergences per chain:", chain_div, "\n")
cat("Rhat > 1.1:", rhat_bad, "\n")

# inclusion probability > 0.8인 DIF 효과 추출
library(posterior)
stan_fdraws <- as_draws_df(stan_f)
dif_detected <- summarise_draws(
  subset_draws(stan_fdraws, variable = c("^pi_ff","^pi_tv"), regex = TRUE)
) %>% filter(mean > 0.8)

cat("\n--- Detected DIF (inclusion prob > 0.8) ---\n")
print(dif_detected)
write.csv(dif_detected, "dif_detected.csv", row.names = FALSE)
