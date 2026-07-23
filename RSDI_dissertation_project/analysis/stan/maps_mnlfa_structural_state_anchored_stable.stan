// Stable, anchor-identified structural-state ordinal MNLFA for Paper 1.
//
// Identification: items in anchor_item have loading = 1 and zero DIF for all
// moderators. Non-anchor loadings and DIF parameters are estimated. All
// numerical bounds below use smooth inv_logit/tanh transforms, not fmin/fmax
// likelihood clamps. Cutpoints are constructed as a strictly ordered, bounded
// smooth transform to prevent invalid ordered-logistic proposals during NUTS.

data {
  int<lower=1> Nobs;
  int<lower=1> P;
  int<lower=1> P_free;
  int<lower=1> Ni;
  int<lower=1> D;
  int<lower=2> K;
  int<lower=1> Q;
  int<lower=1> S;
  int<lower=2> A;
  array[Nobs] int<lower=1, upper=Ni> person;
  array[Nobs] int<lower=1, upper=P> item;
  array[Nobs] int<lower=1, upper=D> wave;
  array[Nobs] int<lower=1, upper=K> Y;
  vector[Nobs] time_score;
  matrix[Nobs, Q] X_dif;
  matrix[Nobs, S] X_state;
  array[A] int<lower=1, upper=P> anchor_item;
  array[P] int<lower=0, upper=P_free> nonanchor_index;
  real<lower=0> sigma_loading_dif;
  real<lower=0> sigma_threshold_dif;
  real<lower=0> sigma_state_effect;
}

parameters {
  vector[P_free] log_loading_free;
  matrix[P_free, Q] loading_dif_free;
  matrix[P_free, Q] threshold_dif_free;
  vector[S] state_effect;
  vector[P] cutpoint_first_raw;
  matrix[P, K - 2] cutpoint_spacing_raw;

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
    cutpoint[j, 1] = -4 + 8 * inv_logit(cutpoint_first_raw[j]);
    for (k in 2:(K - 1)) {
      cutpoint[j, k] = cutpoint[j, k - 1]
        + 0.05 + 1.25 * inv_logit(cutpoint_spacing_raw[j, k - 1]);
    }
  }
}

model {
  log_loading_free ~ normal(0, 0.35);
  to_vector(loading_dif_free) ~ normal(0, sigma_loading_dif);
  to_vector(threshold_dif_free) ~ normal(0, sigma_threshold_dif);
  state_effect ~ normal(0, sigma_state_effect);
  cutpoint_first_raw ~ normal(0, 1);
  to_vector(cutpoint_spacing_raw) ~ normal(0, 1);
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
  real slope_mean = mu_slope;
  real slope_variance = square(growth_sd[2]);
  vector[Nobs] log_lik;
  array[Nobs] int y_rep;
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
