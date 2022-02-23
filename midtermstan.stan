data {
  int N;
  real y[N];
  real Temperature[N];
  real Density[N];
  real Rate[N];
}
parameters {
  real <lower=0> sigma;
  real b0;
  real bTemp;
  real bDens;
  real bRate;
}
transformed parameters{
  real mu[N];
  real <lower=0> sig2;
  sig2 = sigma^2;
  for (i in 1:N){
    mu[i] = b0 + bTemp*Temperature[i] + bDens*Density[i] + bRate*Rate[i];
  }
}
model {
  for (i in 1:N){
    y[i] ~ normal(mu[i],sigma);
  }
  b0 ~ normal(0, 10);
  bTemp ~ normal(0, 10);
  bDens ~ normal(0, 10);
  bRate ~ normal(0, 10);
  sig2 ~ gamma(1.1, 1);

}
generated quantities {
    vector[N] log_lik;
    for (n in 1:N) {
      log_lik[n] = normal_lpdf(y[n] | b0 + bTemp*Temperature[n] + bDens*Density[n] + bRate*Rate[n], sigma);
    }
}
