// MAPS-style longitudinal MNLFA simulation for a graded response model.
// Run with algorithm="Fixed_param"; all data are generated in generated quantities.

data {
  int<lower=1> Nobs;
  int<lower=1> P;
  int<lower=1> Ni;
  int<lower=1> D;
  int<lower=2> K;
  array[Nobs] int<lower=1, upper=Ni> person;
  array[Nobs] int<lower=1, upper=P> itm;
  array[Nobs] int<lower=1, upper=D> time;
  int<lower=1> NFpreds;
  int<lower=1> Ntvpreds;
  matrix[Nobs, NFpreds] Xf;
  matrix[Nobs, Ntvpreds] Xtv;

  vector[P] Lp;
  matrix[P, K - 1] cutpoints;

  vector[P] Ldiftv1;
  vector[P] Ldiftv2;
  vector[P] Ldiff;
  vector[P] Ndiftv1;
  vector[P] Ndiftv2;
  vector[P] Ndiff;

  real mu_intercept;
  real mu_slope;
  vector[2] b_mu_nat2;
  real<lower=0> phi_int;
  real<lower=0> phi_slp;
  real<lower=-0.95, upper=0.95> phi_corr;
  real<lower=0> occasion_sd;
}

generated quantities {
  array[Nobs] int<lower=1, upper=K> Y_sim;
  matrix[2, Ni] growth;
  matrix[D, Ni] theta;
  cov_matrix[2] Sigma;

  Sigma[1, 1] = square(phi_int);
  Sigma[2, 2] = square(phi_slp);
  Sigma[1, 2] = phi_corr * phi_int * phi_slp;
  Sigma[2, 1] = Sigma[1, 2];

  for (i in 1:Ni) {
    growth[, i] = multi_normal_rng(
      [mu_intercept, mu_slope]' + Xf[(i - 1) * P + 1, 1] * b_mu_nat2,
      Sigma
    );
  }

  for (j in 1:Nobs) {
    int p = person[j];
    int t = time[j];
    int item = itm[j];
    real age = Xtv[j, 1];
    real age_sq = Xtv[j, 2];
    real nat2 = Xf[j, 1];
    real disc;
    vector[K - 1] cuts;

    theta[t, p] = growth[1, p] + growth[2, p] * age
      + normal_rng(0, occasion_sd);

    disc = Lp[item]
      + Ldiftv1[item] * age
      + Ldiftv2[item] * age_sq
      + Ldiff[item] * nat2;

    if (disc < 0.2) {
      disc = 0.2;
    }

    cuts = to_vector(cutpoints[item])
      + Ndiftv1[item] * age
      + Ndiftv2[item] * age_sq
      + Ndiff[item] * nat2;

    Y_sim[j] = ordered_logistic_rng(disc * theta[t, p], cuts);
  }
}
