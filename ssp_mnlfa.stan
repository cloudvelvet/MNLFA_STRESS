// Chen & Bauer (2024) Longitudinal MNLFA - SSP Regularized Model (Step 1)
// Spike-and-Slab Prior for DIF detection

data {
  int<lower=1> Nobs;
  int<lower=1> P;
  int<lower=1> Ni;
  int<lower=1> D;
  int<lower=1, upper=Ni> person[Nobs];
  int<lower=1, upper=P>  itm[Nobs];
  int<lower=1, upper=D>  time[Nobs];
  int<lower=0> NFpreds;
  int<lower=0> Ntvpreds;
  int Y[Nobs];
  matrix[Nobs, NFpreds]  Xf;
  matrix[Nobs, Ntvpreds] Xtv;
  matrix[P, (NFpreds+Ntvpreds)] Ldf;
  int<lower=1> Mtv1;   // age main effect DIF count
  int<lower=1> Mtv2;   // age^2 / interaction DIF count
  int<lower=1> Mf;     // time-invariant DIF count
  real<lower=0> sigma_l;
  real<lower=0> sigma_nu;
  real<lower=0> sigma_di;
  real<lower=0> sigma_f;
  real gamma_a;
  real gamma_b;
}

parameters {
  vector<lower=0>[P] Lp;      // item loadings (baseline)
  vector[P]          Np;      // item intercepts (baseline)

  // Lasso scale parameters (SSP)
  real<lower=0> lambda_lf;
  real<lower=0> lambda_nf;
  real<lower=0> lambda_lt1;
  real<lower=0> lambda_nt1;
  real<lower=0> lambda_lt2;
  real<lower=0> lambda_nt2;

  // Raw DIF parameters (before SSP scaling)
  vector[Mf]   L_diff_raw;
  vector[Mtv1] L_diftv1_raw;
  vector[Mtv2] L_diftv2_raw;
  vector[Mf]   n_diff_raw;
  vector[Mtv1] n_diftv1_raw;
  vector[Mtv2] n_diftv2_raw;

  // Inclusion probabilities (spike-and-slab)
  vector<lower=0, upper=1>[P] pi_ff;
  vector<lower=0, upper=1>[P] pi_tv1;
  vector<lower=0, upper=1>[P] pi_tv2;
  vector<lower=0, upper=1>[P] pi_tv3;
  vector<lower=0, upper=1>[P] pi_tv4;

  // Growth model parameters
  real mu_slp;
  real<lower=0> phi_int;
  real<lower=0> phi_slp;
  matrix[2, NFpreds] b_mu;
  matrix[2, NFpreds] b_phi;
  vector[NFpreds] b_phicor;
  real phicorr;
  real b_mu_asq;
  real b_mu_asqint;

  // Latent factors
  matrix[2, Ni] fac_dist;
  matrix[D, Ni] fac_eti_raw;
  real eti_sd2;
}

transformed parameters {
  vector[Mf]   L_diff;
  vector[Mtv1] L_diftv1;
  vector[Mtv2] L_diftv2;
  vector[Mf]   n_diff;
  vector[Mtv1] n_diftv1;
  vector[Mtv2] n_diftv2;

  vector[P]           Ldiff;
  matrix[P, Ntvpreds] Ldiftv;
  vector[P]           Ndiff;
  matrix[P, Ntvpreds] Ndiftv;

  vector[2]          mu_eta = [0, mu_slp]';
  vector<lower=0>[2] phi_eta = [phi_int, phi_slp]';

  // SSP scaling: raw / lambda = regularized DIF
  L_diff   = L_diff_raw   ./ lambda_lf;
  L_diftv1 = L_diftv1_raw ./ lambda_lt1;
  L_diftv2 = L_diftv2_raw ./ lambda_lt2;
  n_diff   = n_diff_raw   ./ lambda_nf;
  n_diftv1 = n_diftv1_raw ./ lambda_nt1;
  n_diftv2 = n_diftv2_raw ./ lambda_nt2;

  // Assign DIF to item vectors
  Ldiff  = rep_vector(0, P);
  Ldiftv = rep_matrix(0, P, Ntvpreds);
  {
    int temp;
    temp = 0;
    for (i in 1:P) {
      if (Ldf[i, (Ntvpreds+1)] == 1) {
        temp = temp + 1;
        Ldiff[i] = L_diff[temp] * pi_ff[temp];
      }
    }
    temp = 0;
    for (i in 1:P) {
      if (Ldf[i, 1] == 1) {
        temp = temp + 1;
        Ldiftv[i, 1] = L_diftv1[temp] * pi_tv1[i];  // age
      }
    }
    temp = 0;
    for (i in 1:P) {
      if (Ldf[i, 2] == 1) {
        temp = temp + 1;
        Ldiftv[i, 2] = L_diftv2[temp] * pi_tv2[i];  // age^2
      }
    }
    for (i in 1:P) {
      if (Ldf[i, 3] == 1) {
        temp = temp + 1;
        Ldiftv[i, 3] = L_diftv2[temp] * pi_tv3[i];  // age*sex
      }
    }
    for (i in 1:P) {
      if (Ldf[i, 4] == 1) {
        temp = temp + 1;
        Ldiftv[i, 4] = L_diftv2[temp] * pi_tv4[i];  // age^2*sex
      }
    }
  }

  Ndiff  = rep_vector(0, P);
  Ndiftv = rep_matrix(0, P, Ntvpreds);
  {
    int temp;
    temp = 0;
    for (i in 1:P) {
      if (Ldf[i, (Ntvpreds+1)] == 1) {
        temp = temp + 1;
        Ndiff[i] = n_diff[temp] * pi_ff[temp];
      }
    }
    temp = 0;
    for (i in 1:P) {
      if (Ldf[i, 1] == 1) {
        temp = temp + 1;
        Ndiftv[i, 1] = n_diftv1[temp] * pi_tv1[i];
      }
    }
    temp = 0;
    for (i in 1:P) {
      if (Ldf[i, 2] == 1) {
        temp = temp + 1;
        Ndiftv[i, 2] = n_diftv2[temp] * pi_tv2[i];
      }
    }
    for (i in 1:P) {
      if (Ldf[i, 3] == 1) {
        temp = temp + 1;
        Ndiftv[i, 3] = n_diftv2[temp] * pi_tv3[i];
      }
    }
    for (i in 1:P) {
      if (Ldf[i, 4] == 1) {
        temp = temp + 1;
        Ndiftv[i, 4] = n_diftv2[temp] * pi_tv4[i];
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

  // Priors
  Lp ~ normal(1, sigma_l);
  Np ~ normal(-2, sigma_nu);

  lambda_lt1 ~ gamma(gamma_a, gamma_b);
  lambda_nt1 ~ gamma(gamma_a, gamma_b);
  lambda_lt2 ~ gamma(gamma_a, gamma_b);
  lambda_nt2 ~ gamma(gamma_a, gamma_b);
  lambda_lf  ~ gamma(gamma_a, gamma_b);
  lambda_nf  ~ gamma(gamma_a, gamma_b);

  L_diff_raw   ~ double_exponential(0, 1);
  n_diff_raw   ~ double_exponential(0, 1);
  L_diftv1_raw ~ double_exponential(0, 1);
  n_diftv1_raw ~ double_exponential(0, 1);
  L_diftv2_raw ~ double_exponential(0, 1);
  n_diftv2_raw ~ double_exponential(0, 1);

  to_vector(b_mu)  ~ normal(0, sigma_f);
  to_vector(b_phi) ~ normal(0, sigma_f);
  b_mu_asq    ~ normal(0, sigma_f);
  b_mu_asqint ~ normal(0, sigma_f);
  b_phicor    ~ normal(0, 1);
  phicorr     ~ normal(0, 1);
  mu_slp      ~ normal(0, sigma_di);
  phi_int     ~ normal(0, sigma_di);
  phi_slp     ~ normal(0, sigma_di);
  eti_sd2     ~ normal(0, 1);

  to_vector(fac_dist)    ~ normal(0, 1);
  to_vector(fac_eti_raw) ~ normal(0, 1);

  pi_ff  ~ beta(0.5, 0.5);
  pi_tv1 ~ beta(0.5, 0.5);
  pi_tv2 ~ beta(0.5, 0.5);
  pi_tv3 ~ beta(0.5, 0.5);
  pi_tv4 ~ beta(0.5, 0.5);

  phi_mat[1, 1] = 1;
  phi_mat[2, 2] = 1;

  // Growth factor distribution
  {
    int k;
    k = 1;
    for (i in 1:Nobs) {
      if (person[i] == k) {
        phi_corr = 1 - 2 / (exp(2 * (phicorr + Xf[i,] * b_phicor)) + 1);
        phi_mat[2, 1] = phi_corr;
        phi_mat[1, 2] = phi_corr;
        fac_gr_helper[, k] = diag_pre_multiply(
          phi_eta .* exp(b_phi * Xf[i,]'),
          cholesky_decompose(phi_mat)
        ) * fac_dist[, k];
        fac_gr[, k] = mu_eta + b_mu * Xf[i,]' + fac_gr_helper[, k];
        k = k + 1;
      }
    }
  }

  // Measurement model likelihood
  {
    int timei;
    int itemi;
    int persi;
    real agei;
    real asq;
    real asqint;

    for (j in 1:Nobs) {
      timei  = time[j];
      agei   = Xtv[j, 1];
      asq    = Xtv[j, 2];
      asqint = Xtv[j, 4];
      itemi  = itm[j];
      persi  = person[j];

      fac_scor[timei, persi] = fac_gr[1, persi]
        + fac_gr[2, persi] * agei
        + b_mu_asq * asq
        + b_mu_asqint * asqint
        + fac_eti_raw[timei, persi] * exp(eti_sd2 * Xf[j, 1]);

      Y[j] ~ bernoulli_logit(
        Np[itemi]
        + Ndiff[itemi]    * Xf[j, 1]
        + Ndiftv[itemi, ] * Xtv[j, ]'
        + (Lp[itemi]
           + Ldiff[itemi]    * Xf[j, 1]
           + Ldiftv[itemi, ] * Xtv[j, ]'
          ) * fac_scor[timei, persi]
      );
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
  real<lower=0> eti_var2;

  phi_mat1[1, 1] = 1; phi_mat1[2, 2] = 1;
  phi_corr1      = 1 - 2 / (exp(2 * phicorr) + 1);
  phi_mat1[2, 1] = phi_corr1;
  phi_mat1[1, 2] = phi_corr1;

  phi_mat2[1, 1] = 1; phi_mat2[2, 2] = 1;
  phi_corr2      = 1 - 2 / (exp(2 * (phicorr + b_phicor[1])) + 1);
  phi_mat2[2, 1] = phi_corr2;
  phi_mat2[1, 2] = phi_corr2;

  phi_var1 = quad_form_diag(phi_mat1, phi_eta * 1);
  phi_var2 = quad_form_diag(phi_mat2, phi_eta .* exp(to_vector(b_phi)));
  eti_var2 = (exp(eti_sd2 * 1))^2;
}
