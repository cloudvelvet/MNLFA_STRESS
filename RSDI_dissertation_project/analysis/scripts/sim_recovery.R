# =============================================================================
# 시뮬레이션 + 파라미터 recovery — longitudinal_ordinal_mnlfa.stan 프로토타입 점검
# -----------------------------------------------------------------------------
# ⚠️ 이 스크립트는 작성 환경(R/cmdstan 미설치)에서 실행되지 않았다.
#    cmdstanr + cmdstan 설치된 로컬에서 그대로 실행 가능하도록 작성한 완결본이다.
#    목적: 모형이 알려진 진값(true params)을 회복하는지 1회 점검(sanity check).
#
# 실행 전: install.packages("cmdstanr", repos=c("https://stan-dev.r-universe.dev"))
#          cmdstanr::install_cmdstan()
# =============================================================================

library(cmdstanr)
set.seed(2026)

# ---- 1) 설계 (작은 규모로 빠른 점검) ----------------------------------------
N <- 500; T <- 3; J <- 8; K <- 4; P <- 1; Q <- 1
time <- 0:(T-1)

# ---- 2) 진값(true parameters) ----------------------------------------------
la0_true <- rnorm(J, 0.4, 0.2)                      # 적재 절편 (log)
la_z_true <- matrix(0, J, P); la_z_true[c(1,2,6),1] <- c(0.4, 0.6, 0.5)  # 비균일 DIF (일부 문항)
b_z_true <- matrix(0, J, P); b_z_true[c(1,2,6),1] <- c(0.5, 0.8, 0.7)    # 균일 DIF (역치 이동)
c_true <- t(sapply(1:J, function(j) sort(rnorm(K-1, c(-1.2,0,1.2), 0.2))))  # 문항별 cutpoints
gimp_true <- 0.3                                    # latent impact
mu_b1_true <- -0.25                                 # 평균 기울기(감소 추세)
tau_b_true <- c(0.8, 0.3)                           # 절편/기울기 SD
rho_b_true <- -0.2

# ---- 3) 공변량 생성 (매 웨이브 측정, 시간에 따라 변동) ----------------------
Zm <- array(rnorm(N*T*P), c(N,T,P))                 # 측정용(차별경험 등) 표준화
Zs <- array(0, c(N,T,Q)); Zs[,,1] <- Zm[,,1]        # 구조용=측정용 동일변수 예시
# 차별경험이 시간에 따라 증가하는 추세 부여(선택)
for (t in 1:T) Zm[,t,1] <- Zm[,t,1] + 0.15*(t-1)

# ---- 4) 개인 무선효과(절편/기울기) -----------------------------------------
Sig <- matrix(c(tau_b_true[1]^2, rho_b_true*prod(tau_b_true),
                rho_b_true*prod(tau_b_true), tau_b_true[2]^2), 2)
L <- chol(Sig)
re <- matrix(rnorm(N*2), N, 2) %*% L
b0 <- re[,1]; b1 <- mu_b1_true + re[,2]

# ---- 5) 응답 생성 (graded-response MNLFA) ----------------------------------
inv_logit <- function(x) 1/(1+exp(-x))
rcat <- function(p) sample(0:(K-1), 1, prob = p)
catp <- function(phi, kappa){ cum <- inv_logit(phi - kappa)
  p <- c(1-cum[1], -diff(cum), cum[length(cum)]); pmax(p,1e-9) }

Y <- array(0L, c(N,T,J)); obs <- array(1L, c(N,T,J))
for (i in 1:N) for (t in 1:T){
  eta <- b0[i] + b1[i]*time[t] + sum(gimp_true*Zs[i,t,])
  for (j in 1:J){
    a <- exp(la0_true[j] + sum(la_z_true[j,]*Zm[i,t,]))
    kappa <- c_true[j,] + sum(b_z_true[j,]*Zm[i,t,])
    Y[i,t,j] <- rcat(catp(a*eta, kappa))
  }
}

# ---- 6) Stan 적합 ----------------------------------------------------------
mod <- cmdstan_model("longitudinal_ordinal_mnlfa.stan")
standata <- list(N=N,T=T,J=J,K=K,P=P,Q=Q, Y=Y, obs=obs, Zm=Zm, Zs=Zs, time=time)
fit <- mod$sample(data=standata, chains=4, parallel_chains=4,
                  iter_warmup=750, iter_sampling=750, seed=2026, refresh=200)

# ---- 7) recovery 점검 ------------------------------------------------------
print(fit$summary(c("mu_b1","gimp","tau_b")), n=50)
# 비균일/균일 DIF 회복: la_z[c(1,2,6),1], b_z[c(1,2,6),1] 추정 vs 진값 비교
sm <- fit$summary(c("la_z","b_z"))
cat("\n진값 la_z(1,2,6)=", la_z_true[c(1,2,6),1],
    "\n진값 b_z (1,2,6)=", b_z_true[c(1,2,6),1], "\n")
print(sm)
# 진단: divergences, R-hat>1.01, low ESS 확인
fit$diagnostic_summary()

# ---- 8) (선택) RSDI 후처리 연결 --------------------------------------------
# source("rsdi_postprocess.R") 후 fit draws + standata 로 시점쌍별 RSDI 계산,
# 진값에서 직접 계산한 "true RSDI"와 비교하면 RSDI recovery 점검이 된다.
