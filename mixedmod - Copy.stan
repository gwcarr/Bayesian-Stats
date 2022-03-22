data {
	int N;
	int p;
	int q;
	int ingot[N];
	int metn[N];
	real pressure[N];
     }
parameters {
	real alpha[p];
	real u[q];
	real <lower=0> serr;
	real <lower=0> sing;
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
