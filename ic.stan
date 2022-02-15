data {
  int<lower=0> N; // number of observations
  real y[N]; // response
  real x[N]; // covariate
}
parameters {
  real  beta0;
  real beta1;
  real<lower=0> sigma;
}
transformed parameters {
  real mu[N];
  real<lower=0> sigma2;
  sigma2 = sigma^2;
  for (i in 1:N) {
    mu[i] = beta0 + beta1*x[i];
  }
}
model {
  beta0 ~ normal(0,100);
  beta1 ~ normal(0,100);  // Normals are (mean, sd)
  sigma ~ gamma(1.1,.1);  // gammas are shape, rate
  for ( i in 1:N) {
    y[i] ~ normal(mu[i],sigma);
  }
}
generated quantities {
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(y[n] | beta0 + beta1*x[n], sigma);
  }
}

