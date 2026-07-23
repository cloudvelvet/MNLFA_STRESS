// ============================================================================
// Longitudinal Ordinal MNLFA — prototype skeleton (논문 1)
// ----------------------------------------------------------------------------
// ⚠️ PROTOTYPE / UNVALIDATED. 식별·prior·수렴 점검 전의 출발 스켈레톤이다.
//    실제 분석 전 연구자가 (a) 식별(앵커), (b) prior 민감도, (c) 수렴(R-hat,
//    ESS, divergences)을 반드시 점검해야 한다. RSDI 분해는 본 모형의 posterior
//    draw를 받아 별도 후처리(rsdi_postprocess.R)에서 계산한다.
//
// 모형 요지 (graded-response 형태의 MNLFA):
//   - 문항 j, 개인 i, 시점 t, 범주 0..K-1
//   - 측정: ordered_logistic(phi_itj, kappa_jt)
//       phi_itj  = a_j(Z_it) * eta_it           (적재 moderation = 비균일 DIF)
//       kappa_jt = c_j + b_j * (B' Z_it)         (역치 moderation = 균일 DIF, 평행이동)
//   - 적재 moderation:  a_j(Z) = exp(la0_j + la_z_j' Z)   (>0 보장)
//   - 구조(성장+impact): eta_it = (b0_i) + (b1_i) * time_t + gimp' Z_it
//       b0_i, b1_i ~ 다변량정규 (개인 절편/기울기 = 잠재 성장)
//   - 식별: 잠재 척도는 b0 평균 0, eta 분산 1 고정(또는 앵커 문항). 아래는 분포고정 예시.
// ============================================================================

data {
  int<lower=1> N;                 // 개인 수
  int<lower=2> T;                 // 웨이브 수 (>=3)
  int<lower=1> J;                 // 문항 수 (=8)
  int<lower=2> K;                 // 응답 범주 수
  int<lower=1> P;                 // 측정용 공변량 수 (차별/한국어/소득 ...)
  int<lower=1> Q;                 // 구조용(잠재 예측) 공변량 수

  array[N, T, J] int<lower=0, upper=K-1> Y;   // 응답 (결측은 별도 처리/마스크 권장)
  array[N, T, J] int<lower=0, upper=1> obs;   // 관측 여부 마스크 (1=관측)

  array[N, T] vector[P] Zm;       // 측정용 공변량 (문항모수 예측)
  array[N, T] vector[Q] Zs;       // 구조용 공변량 (잠재 예측, latent impact)
  array[T] real time;             // 시점 코딩 (예: 0,1,2,...)
}

parameters {
  // --- 측정모형: 적재 ---
  vector[J] la0;                  // 적재 절편 (log scale)
  matrix[J, P] la_z;              // 적재 moderation 계수 (비균일 DIF)

  // --- 측정모형: 역치 ---
  array[J] ordered[K-1] c;        // 문항별 기준 cutpoints (기저)
  matrix[J, P] b_z;               // 역치 moderation 계수 (균일 DIF, 평행이동)

  // --- 구조모형: 잠재 성장 + impact ---
  vector[Q] gimp;                 // latent impact (잠재 평균의 Z 의존)
  real mu_b1;                     // 평균 기울기
  vector<lower=0>[2] tau_b;       // 개인 절편/기울기 표준편차
  cholesky_factor_corr[2] L_b;    // 절편-기울기 상관
  matrix[2, N] z_b;               // 개인 무선효과 (비중심화)
}

transformed parameters {
  matrix[N, 2] b_re;              // [,1]=절편 b0_i, [,2]=기울기 b1_i
  {
    matrix[2, N] tmp = diag_pre_multiply(tau_b, L_b) * z_b;
    for (i in 1:N) {
      b_re[i, 1] = tmp[1, i];                 // b0_i (평균 0 고정 → 척도 식별)
      b_re[i, 2] = mu_b1 + tmp[2, i];         // b1_i
    }
  }
}

model {
  // ---- priors (약정보; 민감도 점검 대상) ----
  la0  ~ normal(0, 1);
  to_vector(la_z) ~ normal(0, 0.5);
  to_vector(b_z)  ~ normal(0, 0.5);
  for (j in 1:J) c[j] ~ normal(0, 2);
  gimp ~ normal(0, 0.5);
  mu_b1 ~ normal(0, 1);
  tau_b ~ normal(0, 1);
  L_b ~ lkj_corr_cholesky(2);
  to_vector(z_b) ~ std_normal();

  // ---- likelihood ----
  for (i in 1:N) {
    for (t in 1:T) {
      // 잠재값: 성장 + impact
      real eta = b_re[i, 1] + b_re[i, 2] * time[t] + dot_product(gimp, Zs[i, t]);
      for (j in 1:J) {
        if (obs[i, t, j] == 1) {
          real a   = exp(la0[j] + dot_product(la_z[j], Zm[i, t]));   // 적재 moderation
          real shift = dot_product(b_z[j], Zm[i, t]);                // 역치 평행이동
          vector[K-1] kappa = c[j] + shift;                         // 이동된 cutpoints
          real phi = a * eta;
          Y[i, t, j] ~ ordered_logistic(phi, kappa);
        }
      }
    }
  }
}

generated quantities {
  // RSDI 후처리에 필요한 최소 출력: 개인×시점 eta, 그리고 문항모수 함수는
  // la0/la_z/c/b_z draw로 후처리에서 재구성한다.
  matrix[N, T] eta_out;
  for (i in 1:N)
    for (t in 1:T)
      eta_out[i, t] = b_re[i, 1] + b_re[i, 2] * time[t] + dot_product(gimp, Zs[i, t]);
  // (선택) log_lik 출력하면 LOO/WAIC 가능 — 분량상 생략, 필요 시 추가.
}
