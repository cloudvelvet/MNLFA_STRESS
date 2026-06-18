// Invariant longitudinal ordinal latent growth model for MAPS parent data.
// This comparator keeps item loadings and thresholds constant over time and
// covariates, while retaining the same latent growth and occasion-residual
// structure as the longitudinal MNLFA model.

data {
  int<lower=1> Nobs;
  int<lower=1> P;
  int<lower=1> Ni;
  int<lower=1> D;
  int<lower=2> K;
  array[Nobs] int<lower=1, upper=Ni> person;
  array[Nobs] int<lower=1, upper=P> item;
  array[Nobs] int<lower=1, upper=D> wave;
  array[Nobs] int<lower=1, upper=K> Y;
  vector[Nobs] time_score;
}

parameters {
  vector[P] log_loading;
  vector[P] cutpoint_first;
  matrix[P, K - 2] log_cutpoint_spacing;

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
    cutpoint[j, 1] = cutpoint_first[j];
    for (k in 2:(K - 1)) {
      cutpoint[j, k] = cutpoint[j, k - 1]
        + exp(fmin(2.0, fmax(-2.0, log_cutpoint_spacing[j, k - 1])));
    }
  }
}

model {
  log_loading ~ normal(0, 0.35);
  cutpoint_first ~ normal(-1.5, 0.75);
  to_vector(log_cutpoint_spacing) ~ normal(0, 0.35);

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
    real eta = eta_intercept[p]
      + eta_slope[p] * time_score[n]
      + occasion_sd * occasion_z[t, p];
    real lambda = exp(fmin(1.5, fmax(-1.5, log_loading[j])));

    Y[n] ~ ordered_logistic(lambda * eta, to_vector(cutpoint[j]));
  }
}

generated quantities {
  corr_matrix[2] growth_cor;
  cov_matrix[2] growth_cov;
  real slope_mean;
  real slope_variance;

  growth_cor = multiply_lower_tri_self_transpose(growth_cor_chol);
  growth_cov = quad_form_diag(growth_cor, growth_sd);
  slope_mean = mu_slope;
  slope_variance = square(growth_sd[2]);
}
