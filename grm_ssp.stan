// Chen & Bauer (2024) Longitudinal MNLFA - GRM + SSP 확장 (Step 1: DIF 탐지)
// 이진 IRT → Graded Response Model (Likert 1-K)
// Spike-and-Slab Prior로 DIF 정규화

data {
  int<lower=1> Nobs;
  int<lower=1> P;          // 문항 수
  int<lower=1> Ni;         // 개인 수
  int<lower=1> D;          // wave 수
  int<lower=2> K;          // 응답 범주 수 (예: 5)
  int<lower=1, upper=Ni> person[Nobs];
  int<lower=1, upper=P>  itm[Nobs];
  int<lower=1, upper=D>  time[Nobs];
  int<lower=1, upper=K>  Y[Nobs];         // 응답 (1~K 정수)
  int<lower=0> NFpreds;                    // 시간불변 예측변수 수 (nation 더미)
  int<lower=0> Ntvpreds;                   // 시간변동 예측변수 수 (age_c, age_c^2)
  matrix[Nobs, NFpreds]  Xf;              // 시간불변: nation 더미
  matrix[Nobs, Ntvpreds] Xtv;            // 시간변동: age_c, age_c^2
  // DIF 패턴 (SSP에서는 전부 1 — 모든 조합을 후보로)
  matrix[P, (NFpreds + Ntvpreds)] Ldf;
  int<lower=1> Mtv;                        // time-varying DIF 파라미터 수
  int<lower=1> Mf;                         // time-invariant DIF 파라미터 수
  // 사전분포 하이퍼파라미터
  real<lower=0> sigma_l;    // loading prior sd
  real<lower=0> sigma_nu;   // threshold prior sd
  real<lower=0> sigma_f;    // growth factor prior sd
  real<lower=0> sigma_di;   // growth sd prior
  real gamma_a;              // SSP gamma shape (큰 값 → 강한 수축)
  real gamma_b;              // SSP gamma rate
}

parameters {
  // ── 측정 모델 ──────────────────────────────────────────────────────────────
  vector<lower=0>[P]  Lp;         // 문항 변별도 (baseline)
  array[P] ordered[K-1] cutraw;  // 문항별 순서형 임계값 (K-1개)

  // SSP lasso scale 파라미터 (loading DIF / threshold DIF 분리)
  real<lower=0> lambda_l_tv;   // time-varying loading DIF
  real<lower=0> lambda_n_tv;   // time-varying threshold DIF
  real<lower=0> lambda_l_f;    // time-invariant loading DIF
  real<lower=0> lambda_n_f;    // time-invariant threshold DIF

  // DIF raw 파라미터 (SSP scaling 전)
  vector[Mtv] L_diftv_raw;    // time-varying loading DIF
  vector[Mf]  L_diff_raw;     // time-invariant loading DIF
  vector[Mtv] n_diftv_raw;    // time-varying threshold DIF (uniform shift)
  vector[Mf]  n_diff_raw;     // time-invariant threshold DIF (uniform shift)

  // SSP inclusion probabilities (아이템별 × 예측변수별)
  // time-varying DIF (age_c, age_c^2): 각 아이템에 inclusion prob
  vector<lower=0, upper=1>[P] pi_tv1;   // age_c loading DIF
  vector<lower=0, upper=1>[P] pi_tv2;   // age_c^2 loading DIF
  // time-invariant DIF: NFpreds개 예측변수 × P 아이템
  // 단순화: 아이템별 하나의 inclusion prob (예측변수 통합)
  // 실제론 matrix[P, NFpreds] 가능하지만 파라미터 절약을 위해 아이템별로
  matrix<lower=0, upper=1>[P, NFpreds] pi_f;  // nation DIF inclusion

  // ── 성장 모델 ──────────────────────────────────────────────────────────────
  real mu_slp;                      // 평균 기울기
  real<lower=0> phi_int;            // 절편 SD
  real<lower=0> phi_slp;            // 기울기 SD
  matrix[2, NFpreds] b_mu;          // nation → 성장인자 평균 효과 (impact)
  matrix[2, NFpreds] b_phi;         // nation → 성장인자 분산 효과
  vector[NFpreds] b_phicor;         // nation → 절편-기울기 상관 효과
  real phicorr;                     // 기저 절편-기울기 상관 (Fisher z)
  matrix[2, Ni] fac_dist;           // non-centered 개인 성장인자
  matrix[D, Ni] fac_eti_raw;        // 시간별 잔차 (non-centered)
  real eti_sd2;                     // 잔차 분산 sex/group 효과
}

transformed parameters {
  // DIF 파라미터 (SSP scaling 적용)
  vector[Mtv] L_diftv = L_diftv_raw ./ lambda_l_tv;
  vector[Mf]  L_diff  = L_diff_raw  ./ lambda_l_f;
  vector[Mtv] n_diftv = n_diftv_raw ./ lambda_n_tv;
  vector[Mf]  n_diff  = n_diff_raw  ./ lambda_n_f;

  // DIF 벡터 (아이템별)
  vector[P]           Ldiff;   // time-invariant loading DIF (아이템별 가중합)
  vector[P]           Ldiftv1; // age_c loading DIF
  vector[P]           Ldiftv2; // age_c^2 loading DIF
  vector[P]           Ndiff;   // time-invariant threshold DIF
  vector[P]           Ndiftv1; // age_c threshold DIF
  vector[P]           Ndiftv2; // age_c^2 threshold DIF

  // 성장 모델 파라미터
  vector[2]          mu_eta = [0, mu_slp]';
  vector<lower=0>[2] phi_eta = [phi_int, phi_slp]';

  // DIF 할당 (SSP inclusion prob 적용)
  // Time-varying DIF
  Ldiftv1 = rep_vector(0, P);
  Ldiftv2 = rep_vector(0, P);
  Ndiftv1 = rep_vector(0, P);
  Ndiftv2 = rep_vector(0, P);
  {
    int temp;
    temp = 0;
    for (i in 1:P) {
      if (Ldf[i, 1] == 1) {
        temp = temp + 1;
        Ldiftv1[i] = L_diftv[temp] * pi_tv1[i];  // age_c loading DIF
        Ndiftv1[i] = n_diftv[temp] * pi_tv1[i];  // age_c threshold DIF
      }
    }
    temp = 0;
    for (i in 1:P) {
      if (Ldf[i, 2] == 1) {
        temp = temp + 1;
        Ldiftv2[i] = L_diftv[temp] * pi_tv2[i];  // age_c^2 loading DIF
        Ndiftv2[i] = n_diftv[temp] * pi_tv2[i];  // age_c^2 threshold DIF
      }
    }
  }

  // Time-invariant DIF (nation: NFpreds 더미 → 아이템별 가중합)
  // 각 아이템의 총 loading DIF = sum_k(L_diff_k * pi_f[i,k] * X_k)
  // 여기선 Ldiff[i]는 스칼라 — X는 likelihood에서 곱함
  // Ldiff[i,k]를 나중에 직접 계산
  Ldiff = rep_vector(0, P);
  Ndiff = rep_vector(0, P);
  {
    int temp;
    temp = 0;
    for (k in 1:NFpreds) {
      for (i in 1:P) {
        if (Ldf[i, Ntvpreds + k] == 1) {
          temp = temp + 1;
          // loading DIF: L_diff[temp] * pi_f[i,k] — 계수는 likelihood에서 Xf 곱해 사용
          // 여기선 pi_f 가중 계수만 저장
          Ldiff[i] = Ldiff[i] + L_diff[temp] * pi_f[i, k];  // 더미별 합산 (간소화)
          Ndiff[i] = Ndiff[i] + n_diff[temp] * pi_f[i, k];
        }
      }
    }
  }
}

model {
  matrix[2, Ni] fac_gr;
  matrix[2, Ni] fac_gr_helper;
  matrix[D, Ni] fac_scor;
  real phi_corr;
  matrix[2, 2]  phi_mat;

  // ── 사전분포 ──────────────────────────────────────────────────────────────
  Lp ~ normal(1, sigma_l);
  // cutpoints: 각 아이템별 ordered 벡터, normal prior on each element
  for (i in 1:P) to_vector(cutraw[i]) ~ normal(0, sigma_nu);

  // SSP lasso scales
  lambda_l_tv ~ gamma(gamma_a, gamma_b);
  lambda_n_tv ~ gamma(gamma_a, gamma_b);
  lambda_l_f  ~ gamma(gamma_a, gamma_b);
  lambda_n_f  ~ gamma(gamma_a, gamma_b);

  // DIF raw: Laplace(double exponential)
  L_diftv_raw ~ double_exponential(0, 1);
  L_diff_raw  ~ double_exponential(0, 1);
  n_diftv_raw ~ double_exponential(0, 1);
  n_diff_raw  ~ double_exponential(0, 1);

  // Inclusion probs: Jeffrey's prior (U-shaped Beta → spike at 0 and 1)
  pi_tv1 ~ beta(0.5, 0.5);
  pi_tv2 ~ beta(0.5, 0.5);
  to_vector(pi_f) ~ beta(0.5, 0.5);

  // 성장 모델
  to_vector(b_mu)  ~ normal(0, sigma_f);
  to_vector(b_phi) ~ normal(0, sigma_f);
  b_phicor         ~ normal(0, 1);
  phicorr          ~ normal(0, 1);
  mu_slp           ~ normal(0, sigma_di);
  phi_int          ~ normal(0, sigma_di);
  phi_slp          ~ normal(0, sigma_di);
  eti_sd2          ~ normal(0, 1);
  to_vector(fac_dist)    ~ normal(0, 1);
  to_vector(fac_eti_raw) ~ normal(0, 1);

  // ── 개인별 성장인자 분포 ───────────────────────────────────────────────────
  phi_mat[1, 1] = 1;
  phi_mat[2, 2] = 1;
  {
    int k;
    k = 1;
    for (i in 1:Nobs) {
      if (person[i] == k) {
        phi_corr = 1 - 2 / (exp(2 * (phicorr + Xf[i, ] * b_phicor)) + 1);
        phi_mat[2, 1] = phi_corr;
        phi_mat[1, 2] = phi_corr;
        fac_gr_helper[, k] = diag_pre_multiply(
          phi_eta .* exp(b_phi * Xf[i, ]'),
          cholesky_decompose(phi_mat)
        ) * fac_dist[, k];
        fac_gr[, k] = mu_eta + b_mu * Xf[i, ]' + fac_gr_helper[, k];
        k = k + 1;
      }
    }
  }

  // ── 측정 모델 우도 (GRM) ───────────────────────────────────────────────────
  {
    int timei;
    int itemi;
    int persi;
    real agei;
    real ag2i;
    real disc;       // effective discrimination (with DIF)
    vector[K-1] cuts; // effective cutpoints (with DIF shift)

    for (j in 1:Nobs) {
      timei = time[j];
      itemi = itm[j];
      persi = person[j];
      agei  = Xtv[j, 1];   // age_c
      ag2i  = Xtv[j, 2];   // age_c^2

      // 개인 시간별 잠재인자 점수
      fac_scor[timei, persi] =
        fac_gr[1, persi]
        + fac_gr[2, persi] * agei
        + fac_eti_raw[timei, persi] * exp(eti_sd2 * Xf[j, 1]);

      // Effective discrimination: baseline + age DIF + age^2 DIF + nation DIF
      disc = Lp[itemi]
           + Ldiftv1[itemi] * agei
           + Ldiftv2[itemi] * ag2i
           + Ldiff[itemi]   * Xf[j, 1];  // nation DIF (가중합, 첫 더미 기준)

      // Effective cutpoints: baseline + uniform threshold shift (DIF)
      // uniform shift → ordering 자동 보존
      cuts = to_vector(cutraw[itemi])
           + Ndiftv1[itemi] * agei
           + Ndiftv2[itemi] * ag2i
           + Ndiff[itemi]   * Xf[j, 1];

      // GRM likelihood
      Y[j] ~ ordered_logistic(disc * fac_scor[timei, persi], cuts);
    }
  }
}

generated quantities {
  cov_matrix[2]  phi_var1;
  cov_matrix[2]  phi_var2;
  corr_matrix[2] phi_mat1;
  corr_matrix[2] phi_mat2;
  real phi_corr1;
  real phi_corr2;

  phi_mat1[1,1] = 1; phi_mat1[2,2] = 1;
  phi_corr1 = 1 - 2 / (exp(2 * phicorr) + 1);
  phi_mat1[2,1] = phi_corr1; phi_mat1[1,2] = phi_corr1;

  phi_mat2[1,1] = 1; phi_mat2[2,2] = 1;
  phi_corr2 = 1 - 2 / (exp(2 * (phicorr + b_phicor[1])) + 1);
  phi_mat2[2,1] = phi_corr2; phi_mat2[1,2] = phi_corr2;

  phi_var1 = quad_form_diag(phi_mat1, phi_eta);
  phi_var2 = quad_form_diag(phi_mat2, phi_eta .* exp(b_phi[, 1]));
}
