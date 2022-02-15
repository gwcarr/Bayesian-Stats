data {
  int N;
  real y[N];
  int gender[N];
  int age[N];
  real bmi[N];
  real hr[N];
  real rpe[N];
}
parameters {
  real <lower=0> sigma;
  real b0;
  real bage;
  real bgen;
  real bbmi;
  real bhr;
  real brpe;
}
transformed parameters{
  real mu[N];
  real <lower=0> sig2;
  sig2 = sigma^2;
  for (i in 1:N){
    mu[i] = b0 + bage*age[i] + bgen*gender[i] + bbmi*bmi[i] +
            bhr*hr[i] + brpe*rpe[i];
  }
}
model {
  for (i in 1:N){
    y[i] ~ normal(mu[i],sigma);
  }
  b0 ~ normal(20,100);
  bage ~ normal(0,100);
  bgen ~ normal(0,100);
  bbmi ~ normal(0,100);
  bhr ~ normal(0,100);
  brpe ~ normal(0,100);
  sigma ~ gamma(2,.25);

}
generated quantities {
  vector[N] log_lik;
  for (n in 1:N) log_lik[n] = normal_lpdf(y[n] | b0 + bage*age[n] + bgen*gender[n] + bbmi*bmi[n] + bhr*hr[n] + brpe*rpe[n] , sigma);
}
