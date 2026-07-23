// Anchor-identified structural-state ordinal MNLFA for Paper 1.
//
// This is deliberately separate from maps_mnlfa_structural_state.stan.
// Items in anchor_item have loading = 1 (log-loading = 0) and zero DIF
// moderation for every covariate. Non-anchor item parameters are estimated
// without hard clamps. The model is intended for confirmatory calibration,
// not to overwrite the legacy exploratory results automatically.

data {
  int<lower=1> Nobs;
  int<lower=1> P;
  int<lower=1> Ni;
  int<lower=1> D;
  int<lower=2> K;
  int<lower=1> Q;
  int<lower=1> S;
  int<lower=1> A;
  int<lower=0> P_free;
  array[Nobs] int<lower=1, upper=Ni> person;
  array[Nobs] int<lower=1, upper=P> item;
  array[Nobs] int<lower=1, upper=D> wave;
  array[Nobs] int<lower=1, upper=K> Y;
  vector[Nobs] time_score;
  matrix[Nobs, Q] X_dif;
  matrix[Nobs, S] X_state;
  array[A] int<lower=1, upper=P> anchor_item;
  array[P] int<lower=0, upper=P> nonanchor_index;
  real<lower=0> sigma_loading_dif;
  real<lower=0> sigma_threshold_dif;
  real<lower=0> sigma_state_effect;
}

parameters {
  vector[P_free] log_loading_free;
  matrix[P_free, Q] loading_dif_free;
  matrix[P_free, Q] threshold_dif_free;
  vector[S] state_effect;
  vector[P] raw_cutpoint_first;
  matrix[P, K - 2] raw_cutpoint_spacing;

  real mu_slope;
  vector<lower=0>[2] growth_sd;
  cholesky_factor_corr[2] growth_cor_chol;
  matrix[2, Ni] growth_z;
  real<lower=0> occasion_sd;
  matrix[D, Ni] occasion_z;
}

transformed parameters {
  matrix[2, Ni] growth_re;
  vector[Ni] eta_intercept;
  vector[Ni] eta_slope;
  array[P] vector[K - 1] cutpoint;

  growth_re = diag_pre_multiply(growth_sd, growth_cor_chol) * growth_z;
  eta_intercept = to_vector(growth_re[1, ]);
  eta_slope = mu_slope + to_vector(growth_re[2, ]);

  for (j in 1:P) {
    cutpoint[j, 1] = 3.0 * tanh(raw_cutpoint_first[j]);
    for (k in 2:(K - 1)) {
      cutpoint[j, k] = cutpoint[j, k - 1]
        + 0.1 + 2.0 * inv_logit(raw_cutpoint_spacing[j, k - 1]);
    }
  }
}
model {
  // Priors are intentionally moderately regularizing because the marker
  // anchor fixes the latent scale instead of a clamp.
  log_loading_free ~ normal(0, 0.35);
  to_vector(loading_dif_free) ~ normal(0, sigma_loading_dif);
  to_vector(threshold_dif_free) ~ normal(0, sigma_threshold_dif);
  state_effect ~ normal(0, sigma_state_effect);
  raw_cutpoint_first ~ normal(0, 1);
  to_vector(raw_cutpoint_spacing) ~ normal(0, 1);

  mu_slope ~ normal(0, 0.5);
  growth_sd ~ normal(0, 0.75);
  growth_cor_chol ~ lkj_corr_cholesky(2);
  to_vector(growth_z) ~ normal(0, 1);
  occasion_sd ~ normal(0, 0.5);
  to_vector(occasion_z) ~ normal(0, 1);

  for (n in 1:Nobs) {
    int p = person[n];
    int j = item[n];
    int t = wave[n];
    int fj = nonanchor_index[j];
    real eta = eta_intercept[p]
      + eta_slope[p] * time_score[n]
      + dot_product(X_state[n], state_effect)
      + occasion_sd * occasion_z[t, p];
    real log_lambda_eff;
    real threshold_shift;
    vector[K - 1] shifted_cutpoint;

    if (fj == 0) {
      // All anchor loadings are exactly 1 and all anchor DIF is exactly 0.
      log_lambda_eff = 0;
      threshold_shift = 0;
    } else {
      log_lambda_eff = 1.5 * tanh(log_loading_free[fj]
        + tanh(dot_product(X_dif[n], loading_dif_free[fj]')));
      threshold_shift = 2.5 * tanh(dot_product(X_dif[n], threshold_dif_free[fj]'));
    }
    shifted_cutpoint = to_vector(cutpoint[j]) + threshold_shift;
    Y[n] ~ ordered_logistic(exp(log_lambda_eff) * eta, shifted_cutpoint);
  }
}

generated quantities {
  corr_matrix[2] growth_cor;
  cov_matrix[2] growth_cov;
  real slope_mean;
  real slope_variance;
  vector[Nobs] log_lik;
  array[Nobs] int y_rep;

  growth_cor = multiply_lower_tri_self_transpose(growth_cor_chol);
  growth_cov = quad_form_diag(growth_cor, growth_sd);
  slope_mean = mu_slope;
  slope_variance = square(growth_sd[2]);

  for (n in 1:Nobs) {
    int p = person[n];
    int j = item[n];
    int t = wave[n];
    int fj = nonanchor_index[j];
    real eta = eta_intercept[p]
      + eta_slope[p] * time_score[n]
      + dot_product(X_state[n], state_effect)
      + occasion_sd * occasion_z[t, p];
    real log_lambda_eff;
    real threshold_shift;
    vector[K - 1] shifted_cutpoint;

    if (fj == 0) {
      log_lambda_eff = 0;
      threshold_shift = 0;
    } else {
      log_lambda_eff = 1.5 * tanh(log_loading_free[fj]
        + tanh(dot_product(X_dif[n], loading_dif_free[fj]')));
      threshold_shift = 2.5 * tanh(dot_product(X_dif[n], threshold_dif_free[fj]'));
    }
    shifted_cutpoint = to_vector(cutpoint[j]) + threshold_shift;
    log_lik[n] = ordered_logistic_lpmf(Y[n] | exp(log_lambda_eff) * eta,
                                       shifted_cutpoint);
    y_rep[n] = ordered_logistic_rng(exp(log_lambda_eff) * eta,
                                    shifted_cutpoint);
  }
}
