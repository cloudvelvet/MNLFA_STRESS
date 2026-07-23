# =============================================================================
# RSDI 후처리 — Stan posterior draw로부터 시점쌍별·문항별 RSDI 계산 (논문 1)
# -----------------------------------------------------------------------------
# ⚠️ PROTOTYPE / UNVALIDATED. longitudinal_ordinal_mnlfa.stan 적합 결과를 받아
#    §3.5.1의 개인 조건부 분해를 draw 단위로 계산하는 스켈레톤이다. 경계 처리·
#    집계 규칙·민감도(분해 순서, 3-way 확장)는 연구자가 확정해야 한다.
#
# 입력: fit (cmdstanr/rstan), data list (Y, Zm, time, N,T,J,K,P ...)
# 출력: 시점쌍 (t0->t1) × 문항 j 별 RSDI 의 사후분포
# =============================================================================

# --- 1) draw 추출 (cmdstanr 가정) -------------------------------------------
# draws <- fit$draws(format = "df")  # la0[j], la_z[j,p], c[j,k], b_z[j,p], eta_out[i,t]
# 아래는 의사코드 수준의 함수형 스켈레톤.

inv_logit <- function(x) 1 / (1 + exp(-x))

# 누적 cutpoints(kappa)와 phi로부터 범주확률 벡터 P(Y=0..K-1) 계산
cat_probs <- function(phi, kappa) {            # kappa: 길이 K-1 (오름차순)
  cum <- inv_logit(phi - kappa)                # P(Y >= k), k=1..K-1
  p <- numeric(length(kappa) + 1)
  p[1] <- 1 - cum[1]
  if (length(kappa) > 1)
    for (k in 2:length(kappa)) p[k] <- cum[k-1] - cum[k]
  p[length(p)] <- cum[length(cum)]
  pmax(p, 1e-12)                               # 수치 안정
}

tv <- function(p, q) 0.5 * sum(abs(p - q))      # total variation distance

# 한 draw, 한 개인 i, 한 문항 j, 시점쌍 (t0,t1)에 대한 성분
decompose_one <- function(la0_j, la_z_j, c_j, b_z_j,
                          eta_t0, eta_t1, Zm_t0, Zm_t1) {
  m <- function(eta, Z) {
    a     <- exp(la0_j + sum(la_z_j * Z))
    kappa <- c_j + sum(b_z_j * Z)
    cat_probs(a * eta, kappa)
  }
  p00 <- m(eta_t0, Zm_t0)                        # 기준
  total <- m(eta_t1, Zm_t1) - p00
  latent <- m(eta_t1, Zm_t0) - p00              # Z 고정, eta 이동
  measurement <- m(eta_t0, Zm_t1) - p00         # eta 고정, Z 이동
  interaction <- total - latent - measurement
  list(L = tv(latent + p00, p00),               # ||latent||_TV
       M = tv(measurement + p00, p00),
       I = tv(interaction + p00, p00))
}

# RSDI: 분모 임계 미만이면 NA(경계 불안정성, §3.3)
rsdi_from_components <- function(L, M, I, denom_min = 1e-3) {
  denom <- L + M + I
  ifelse(denom < denom_min, NA_real_, M / denom)
}

# --- 2) 집계 루프 (의사코드) -------------------------------------------------
# for (draw in draws) {
#   for (pair in list(c(1,2), c(2,3), c(1,3))) {   # 인접쌍 + 전구간
#     for (j in 1:J) {
#       Ls <- Ms <- Is <- numeric(N)
#       for (i in 1:N) {
#         comp <- decompose_one(la0[j], la_z[j,], c[j,], b_z[j,],
#                               eta[i,pair[1]], eta[i,pair[2]],
#                               Zm[i,pair[1],], Zm[i,pair[2],])
#         Ls[i] <- comp$L; Ms[i] <- comp$M; Is[i] <- comp$I
#       }
#       # 문항 수준: 개인 평균 후 비율 (draw별 RSDI 1값)
#       RSDI_draw[draw, pair, j] <- rsdi_from_components(mean(Ls), mean(Ms), mean(Is))
#     }
#   }
# }
#
# --- 3) 요약: 시점쌍×문항 RSDI 사후분포 -------------------------------------
# summarise: 중앙값 + 95% 신뢰구간, 인접쌍 RSDI 시간추세 플롯.
# 민감도: 분해 순서 반전 / Shapley 평균(§3.2), 3-way 확장(§3.5.4)도 동일 골격.
#
# NOTE: 대규모(N×T×J×draws) 계산이므로 벡터화/행렬화 또는 Rcpp 권장.
