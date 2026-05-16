// Chen & Bauer (2024) Longitudinal MNLFA - GRM 비정규화 재추정 (Step 2)
// SSP 없이 탐지된 DIF 패턴만 포함하여 재추정

data {
  int<lower=1> Nobs;
  int<lower=1> P;
  int<lower=1> Ni;
  int<lower=1> D;
  int<lower=2> K;
  int<lower=1, upper=Ni> person[Nobs];
  int<lower=1, upper=P>  itm[Nobs];
  int<lower=1, upper=D>  time[Nobs];
  int<lower=1, upper=K>  Y[Nobs];
  int<lower=0> NFpreds;
  int<lower=0> Ntvpreds;
  matrix[Nobs, NFpreds]  Xf;
  matrix[Nobs, Ntvpreds] Xtv;
  // DIF 패턴 행렬 (Step 1 결과 기반으로 수동 설정)
  // 행=아이템, 열=예측변수(age_c, age_c^2, nation dummies...)
  // 1=DIF 있음, 0=없음
  matrix[P, (NFpreds + Ntvpreds)] Ldf;
  int<lower=0> Mtv;   // time-varying DIF 파라미터 수
  int<lower=0> Mf;    // time-invariant DIF 파라미터 수 (nation)
  real<lower=0> sigma_l;
  real<lower=0> sigma_nu;
  real<lower=0> sigma_f;
  real<lower=0> sigma_di;
}

parameters {
  // ── 측정 모델 ──────────────────────────────────────────────────────────────
  vector<lower=0>[P]      Lp;
  array[P] ordered[K-1]  cutpoints;

  // DIF 파라미터 (확정된 패턴만)
  vector[Mtv] L_diftv;   // time-varying loading DIF
  vector[Mf]  L_diff;    // time-invariant loading DIF
  vector[Mtv] n_diftv;   // time-varying threshold DIF
  vector[Mf]  n_diff;    // time-invariant threshold DIF

  // ── 성장 모델 ──────────────────────────────────────────────────────────────
  real mu_slp;
  real<lower=0> phi_int;
  real<lower=0> phi_slp;
  matrix[2, NFpreds] b_mu;
  matrix[2, NFpreds] b_phi;
  vector[NFpreds] b_phicor;
  real phicorr;
  matrix[2, Ni] fac_dist;
  matrix[D, Ni] fac_eti_raw;
  real eti_sd2;
}

transformed parameters {
  // DIF 벡터 (아이템별, 패턴에 따라 할당)
  vector[P] Ldiftv1; // age_c loading DIF
  vector[P] Ldiftv2; // age_c^2 loading DIF
  vector[P] Ldiff_v; // nation loading DIF (첫 번째 nation 더미 기준)
  vector[P] Ndiftv1;
  vector[P] Ndiftv2;
  vector[P] Ndiff_v;

  vector[2]          mu_eta  = [0, mu_slp]';
  vector<lower=0>[2] phi_eta = [phi_int, phi_slp]';

  Ldiftv1 = rep_vector(0, P);
  Ldiftv2 = rep_vector(0, P);
  Ldiff_v = rep_vector(0, P);
  Ndiftv1 = rep_vector(0, P);
  Ndiftv2 = rep_vector(0, P);
  Ndiff_v = rep_vector(0, P);

  {
    int temp;
    // age_c DIF
    temp = 0;
    for (i in 1:P) {
      if (Ldf[i, 1] == 1) {
        temp = temp + 1;
        Ldiftv1[i] = L_diftv[temp];
        Ndiftv1[i] = n_diftv[temp];
      }
    }
    // age_c^2 DIF
    temp = 0;
    for (i in 1:P) {
      if (Ldf[i, 2] == 1) {
        temp = temp + 1;
        Ldiftv2[i] = L_diftv[Mtv/2 + temp];  // 두 번째 절반
        Ndiftv2[i] = n_diftv[Mtv/2 + temp];
      }
    }
    // nation DIF (time-invariant, Xf의 첫 컬럼 기준 — 실제론 아이템×더미별로 확장 가능)
    temp = 0;
    for (i in 1:P) {
      if (Ldf[i, Ntvpreds + 1] == 1) {
        temp = temp + 1;
        Ldiff_v[i] = L_diff[temp];
        Ndiff_v[i] = n_diff[temp];
      }
    }
  }
}

model {
  matrix[2, Ni] fac_gr;
  matrix[2, Ni] fac_gr_helper;
  matrix[D, Ni] fac_scor;
  real phi_corr;
  matrix[2, 2] phi_mat;

  // ── 사전분포 ──────────────────────────────────────────────────────────────
  Lp ~ normal(1, sigma_l);
  for (i in 1:P) to_vector(cutpoints[i]) ~ normal(0, sigma_nu);

  L_diftv ~ normal(0, sigma_di);
  L_diff  ~ normal(0, sigma_di);
  n_diftv ~ normal(0, sigma_di);
  n_diff  ~ normal(0, sigma_di);

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

  // ── 성장인자 분포 ─────────────────────────────────────────────────────────
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

  // ── GRM 우도 ──────────────────────────────────────────────────────────────
  {
    int timei; int itemi; int persi;
    real agei; real ag2i;
    real disc;
    vector[K-1] cuts;

    for (j in 1:Nobs) {
      timei = time[j];
      itemi = itm[j];
      persi = person[j];
      agei  = Xtv[j, 1];
      ag2i  = Xtv[j, 2];

      fac_scor[timei, persi] =
        fac_gr[1, persi]
        + fac_gr[2, persi] * agei
        + fac_eti_raw[timei, persi] * exp(eti_sd2 * Xf[j, 1]);

      disc = Lp[itemi]
           + Ldiftv1[itemi] * agei
           + Ldiftv2[itemi] * ag2i
           + Ldiff_v[itemi] * Xf[j, 1];

      cuts = to_vector(cutpoints[itemi])
           + Ndiftv1[itemi] * agei
           + Ndiftv2[itemi] * ag2i
           + Ndiff_v[itemi] * Xf[j, 1];

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
  phi_var2 = quad_form_diag(phi_mat2, phi_eta .* exp(to_vector(b_phi)));
}
