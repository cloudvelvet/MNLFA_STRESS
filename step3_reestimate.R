# Chen & Bauer (2024) Longitudinal MNLFA
# Step 3: Re-estimation with detected DIF pattern (2단계 — 비정규화 재추정)

library(Rcpp)
library(rstan)
library(dplyr)

options(mc.cores = 4)
rstan_options(auto_write = TRUE)

# ── DIF 탐지 결과 확인 후 패턴 지정 ──────────────────────────────────────────
# step2에서 pi > 0.8인 DIF를 확인하고 Ldf 행렬을 수동으로 설정
# 논문 결과(Add Health): 아래 패턴 사용
#   col1=age DIF, col2=age^2 DIF, col3=age*sex DIF, col4=sex DIF
#   items: graffiti(1), dmgprop(2), lie(3), car(4), stealm(5),
#          house(6), selldrg(7), steall(8), unruly(9)

longdat <- read.csv("longdat.csv") %>%
  mutate(
    age2  = (age - 17.5) / 6,
    agesq = age2^2,
    agsx  = age2 * BIO_SEX
  )

path     <- "lssAH-at"
Nobs     <- nrow(longdat)
P        <- length(unique(longdat$item))
Ni       <- length(unique(longdat$ID))
D        <- length(unique(longdat$wave))
person   <- longdat$ID
itm      <- as.numeric(longdat$item)
time     <- as.numeric(longdat$wave)

Xtv      <- as.matrix(cbind(longdat$age2, longdat$agesq, longdat$agsx))
Xf       <- as.matrix(longdat$BIO_SEX)
NFpreds  <- ncol(Xf)    # 1
Ntvpreds <- ncol(Xtv)   # 3
Y        <- longdat$resp

# DIF 패턴 행렬 (논문 Table 결과 기반)
# 행=아이템(1-9), 열=예측변수(age, age^2, age*sex, sex)
# 1=DIF 있음, 0=없음
Ldf <- matrix(c(
  # age  agesq  age*sex  sex
    0,    1,     1,       0,   # graffiti(1)
    1,    1,     0,       1,   # dmgprop(2)
    1,    1,     0,       0,   # lie(3)
    1,    0,     0,       0,   # car(4)
    1,    0,     0,       0,   # stealm(5)
    0,    0,     0,       0,   # house(6)
    1,    0,     0,       1,   # selldrg(7)
    0,    0,     0,       0,   # steall(8)
    1,    0,     0,       1    # unruly(9)
), nrow = P, ncol = 4, byrow = TRUE)

Mtv1 <- sum(Ldf[, 1:(Ntvpreds - 2)])           # age main effect
Mtv2 <- sum(Ldf[, (Ntvpreds - 1):Ntvpreds])    # age^2, age*sex
Mf   <- sum(Ldf[, (Ntvpreds + 1):(Ntvpreds + NFpreds)])  # sex

fa.data <- list(
  Nobs = Nobs, P = P, Ni = Ni, D = D,
  person = person, itm = itm, time = time,
  NFpreds = NFpreds, Ntvpreds = Ntvpreds,
  Y = Y, Xf = Xf, Xtv = Xtv, Ldf = Ldf,
  Mtv1 = Mtv1, Mtv2 = Mtv2, Mf = Mf,
  sigma_l = 1.5, sigma_nu = 1.5, sigma_di = 1,
  sigma_cor = 1.5, sigma_f = 1.5
)

init_cat <- function() {
  list(
    Lp          = runif(P,     1,   1.5),
    Np          = runif(P,    -1,   0),
    L_diff      = runif(Mf,    0,   .1),
    L_diftv     = runif(Mtv1,  0,   .1),
    L_diftv2    = runif(Mtv2,  0,   .1),
    n_diff      = runif(Mf,    0,   .1),
    n_diftv     = runif(Mtv1,  0,   .1),
    n_diftv2    = runif(Mtv2,  0,   .1),
    b_mu        = matrix(runif(2 * NFpreds, 0, .05), nrow = 2),
    b_phi       = matrix(runif(2 * NFpreds, 0, .05), nrow = 2),
    b_mu_asq    = runif(1, 0, .1),
    b_mu_asqint = runif(1, 0, .1),
    mu_slp      = runif(1, 0, .1),
    phi_slp     = runif(1, 0, .1),
    phi_int     = runif(1, 0, .1)
  )
}

# AH.stan = numerical example Stan 코드와 동일한 구조 (SSP 없음)
stan_m <- stan_model(file = "AH.stan", verbose = FALSE)

stan_f <- sampling(
  stan_m,
  data    = fa.data,
  pars    = c("Lp","Np","Ldiff","Ldiftv","Ndiff","Ndiftv",
              "mu_eta","b_mu","b_phi","b_mu_asq","b_mu_asqint",
              "eti_var2","phi_var1","phi_var2",
              "phi_eta","phicorr","b_phicor","fac_gr"),
  chains  = 4,
  warmup  = 1000,
  iter    = 2500,
  init    = init_cat,
  cores   = 4,
  control = list(adapt_delta = 0.86, max_treedepth = 13),
  seed    = 198
)

save.image("lss-final.RData")

fit_summary <- as.data.frame(
  summary(stan_f,
          pars = c("Lp","Np","Ldiff","Ldiftv","Ndiff","Ndiftv",
                   "mu_eta","b_mu","b_phi","b_mu_asq","b_mu_asqint",
                   "eti_var2","phi_var1","phi_var2","phi_eta","phicorr","b_phicor"),
          probs = c(0.025, 0.5, 0.975))$summary
)
print(fit_summary)

sampler_params <- get_sampler_params(stan_f, inc_warmup = FALSE)
chain_div  <- sapply(sampler_params, function(x) sum(x[, "divergent__"]))
cat("Divergences:", chain_div, "\n")
cat("Rhat > 1.1:", sum(fit_summary$Rhat > 1.1, na.rm = TRUE), "\n")
