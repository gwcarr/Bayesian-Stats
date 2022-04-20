data {
	int N;
	int n_AO;
	int n_DI;
	int n_grp;
	int n_tmt;
	array[N] int groupid;
	array[N] int tmt;
	array[N] real TII2;
     }

transformed data {
  array[N] real sq_TII2;
  sq_TII2 = TII2^2;
}

parameters {
	array[n_grp] real <lower=0> group_mu;
	real <lower=0> tmt_eff;
	real <lower=0> serr;
	real <lower=0> stmt;
	real <lower=0> sgrp;
           }
transformed parameters {
	real s2err;
	real s2tmt;
	real s2grp;
	s2err = serr^2;
	s2tmt = stmt^2;
	s2grp = sgrp^2;
           }
model {
	// Priors
  for (j in 1:n_grp) {
    group_mu[j] ~ normal(1, sgrp);
  }
	tmt_eff ~ normal(0.1, stmt);
	serr ~ gamma(2, 3);
	// Hyper-Priors
	stmt ~ gamma(2, 7);
	sgrp ~ gamma(2, 3);
	for (i in 1:N) {
   sq_TII2[i] ~ normal(group_mu[groupid[i]] - tmt_eff*tmt[i], serr);
	}
      }
