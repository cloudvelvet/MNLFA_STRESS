// MAPS parent-data simulation with time-varying DIF predictors.
// Run with CmdStan fixed_param.

data {
  int<lower=1> Nobs;
  int<lower=1> P;
  int<lower=1> Ni;
  int<lower=1> D;
  int<lower=2> K;
  int<lower=1> Q;
  array[Nobs] int<lower=1, upper=Ni> person;
  array[Nobs] int<lower=1, upper=P> item;
  array[Nobs] int<lower=1, upper=D> wave;
  vector[D] time_value;
  matrix[Nobs, Q] X_dif;

  vector[P] log_loading;
  matrix[P, K - 1] cutpoints;
  matrix[P, Q] loading_dif;
  matrix[P, Q] threshold_dif;

  real mu_intercept;
  real mu_slope;
  real<lower=0> intercept_sd;
  real<lower=0> slope_sd;
  real<lower=-0.95, upper=0.95> growth_corr;
  real<lower=0> occasion_sd;
}

generated quantities {
  array[Nobs] int<lower=1, upper=K> Y_sim;
  matrix[2, Ni] growth;
  matrix[D, Ni] theta;
  cov_matrix[2] Sigma;

  Sigma[1, 1] = square(intercept_sd);
  Sigma[2, 2] = square(slope_sd);
  Sigma[1, 2] = growth_corr * intercept_sd * slope_sd;
  Sigma[2, 1] = Sigma[1, 2];

  for (i in 1:Ni) {
    growth[, i] = multi_normal_rng([mu_intercept, mu_slope]', Sigma);
    for (t in 1:D) {
      theta[t, i] = growth[1, i] + growth[2, i] * time_value[t]
        + normal_rng(0, occasion_sd);
    }
  }

  for (n in 1:Nobs) {
    int p = person[n];
    int j = item[n];
    int t = wave[n];
    real eta;
    real log_lambda_eff;
    real lambda;
    real threshold_shift;
    vector[K - 1] cuts;

    eta = theta[t, p];

    log_lambda_eff = log_loading[j] + dot_product(X_dif[n], loading_dif[j]');
    log_lambda_eff = fmin(1.5, fmax(-1.5, log_lambda_eff));
    lambda = exp(log_lambda_eff);

    threshold_shift = dot_product(X_dif[n], threshold_dif[j]');
    threshold_shift = fmin(3.0, fmax(-3.0, threshold_shift));
    cuts = to_vector(cutpoints[j]) + threshold_shift;

    Y_sim[n] = ordered_logistic_rng(lambda * eta, cuts);
  }
}
