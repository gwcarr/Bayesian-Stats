data {
	int N;
  array[N] int roof;
  array[N] int basmt;
  array[N] real area;
  array[N] real price;
}

transformed data {
  array[N] real pricesqrt;
  for (i in 1:N) {
    pricesqrt[i] = sqrt(price[i]);
  }
}

parameters {
// Betas
	real beta0;
  real barea;
  real broof;
  real bbasmt;
// Deviation
	real <lower=0> serr;
}

transformed parameters {
	real s2err;
	s2err = serr^2;
  array[N] real mu;
  for (i in 1:N) {
	  mu[i] = beta0 + barea*area[i] + broof*roof[i] + bbasmt*basmt[i];
  }
}

model {
  beta0 ~ normal(0, 10);
  barea ~ normal(0, 10);
  broof ~ normal(0, 10);
  bbasmt ~ normal(0, 10);
	s2err ~ gamma(3,0.1);
  for (i in 1:N) {
    pricesqrt[i] ~ normal(mu[i], serr);
  }
}
