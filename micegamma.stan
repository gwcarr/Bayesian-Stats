
data {
  int<lower=0> N;
  int<lower=0> Ncen;
  int<lower=0> Nnotcen;
  int<lower=0> Ntmts;
  vector[Ncen] cenTime;
  vector[Nnotcen] notcenTime;
  vector[Ncen] centmt1;
  vector[Ncen] centmt2;
  vector[Ncen] centmt3;
  vector[Ncen] centmt4;
  vector[Nnotcen] notcentmt1;
  vector[Nnotcen] notcentmt2;
  vector[Nnotcen] notcentmt3;
  vector[Nnotcen] notcentmt4;
}

parameters {
  vector<lower=0>[Ntmts] shape;
  real<lower=0> rate;
}
transformed parameters {
  vector<lower=0>[Ntmts] meansurv;
  for (i in 1:Ntmts){
    meansurv[i] = shape[i]/rate;
  }
}
model {
  for (i in 1:Ntmts){
    shape[i] ~ gamma(1.1,.1);
  }
  rate ~ gamma(1.1,.1);
  target += gamma_lpdf(notcenTime | shape[1]*notcentmt1 + shape[2]*notcentmt2 + shape[3]*notcentmt3 + shape[4]*notcentmt4, rate); 
  target += gamma_lccdf(cenTime | shape[1]*centmt1 + shape[2]*centmt2 + shape[3]*centmt3 + shape[4]*centmt4, rate);
}
generated quantities{
  vector[N] log_lik;
  for (n in 1:Nnotcen) log_lik[n] = gamma_lpdf(notcenTime[n] | shape[1]*notcentmt1[n] + shape[2]*notcentmt2[n] + shape[3]*notcentmt3[n] + shape[4]*notcentmt4[n], rate);
  for (n in (Nnotcen+1):(Nnotcen+Ncen)) log_lik[n] = gamma_lccdf(cenTime[n-Nnotcen] | shape[1]*centmt1[n-Nnotcen] + shape[2]*centmt2[n-Nnotcen] + shape[3]*centmt3[n-Nnotcen] + shape[4]*centmt4[n-Nnotcen], rate);
}
