data {
  int N;
  array[N] real y;
  array[N] real x;
}
parameters {
  real <lower=0> sigma;
  real a;
  real <lower=0> b;
  real <lower=0, upper=1> g;
}
transformed parameters{
  array[N] real mu;
  real <lower=0> sig2;
  sig2 = sigma^2;
  for (i in 1:N){
    mu[i] = a - b * g ^ x[i];
  }
}
model {
  for (i in 1:N){
    y[i] ~ normal(mu[i],sigma);
  }
  a ~ normal(3,31.62);
  b ~ gamma(6, 0.25);
  g ~ beta(5.5, 1.5);
  sigma ~ gamma(2,.25);
}
