data {
	int N;
	int n_AO;
	int n_DI;
	int n_grp;
	array[N] real TII2;
     }
parameters {
	real ;
	real u[q];
	real <lower=0> serr;
	real <lower=0> sgrp;
           }
transformed parameters {
	real s2err;
	real s2ing;
	real sdiag;
	s2ing = sing^2;
	s2err = serr^2;
	sdiag = sqrt(s2ing+s2err);
           }
model {
	u ~ normal(0,sing);
	serr ~ gamma(1.1,.1);
	sing ~ gamma(1.1,.1);
  alpha ~ normal(75,100);
	for (i in 1:N) {
		pressure[i]~normal(alpha[metn[i]]+u[ingot[i]],serr);
                       }
      }
generated quantities {
  vector[N] log_lik;
  for (n in 1:N) log_lik[n] = normal_lpdf(pressure[n] | alpha[metn[n]]+u[ingot[n]],sdiag);
}
