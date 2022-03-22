data {
	int <lower=1> p;
	int <lower=1> q;
	matrix[q,p] ming;
	matrix[q,p] tmt;
	matrix[q,p] y;
     }
parameters {
	vector[p] alpha;
	real u[q];
	real <lower=0> serr;
	real <lower=0> sing;
           }     
transformed parameters {
	real s2err;
	real s2ing;
	cov_matrix[p]  vv;
	s2ing = sing^2;
	s2err = serr^2;
	for (i in 1:p){
	  for (j in 1:p){
	    if (i==j) vv[i,j]=s2err+s2ing;
	    else vv[i,j]=s2ing;
	  }
	}
}
model {
	u ~ normal(0,sing);
	serr ~ gamma(1.1,.1);
	sing ~ gamma(1.1,.1);
  alpha ~ normal(75,100);
	for (i in 1:q) {
		y[i,1:3]~multi_normal(u[i] + alpha[1:3],vv);
    }
}
generated quantities {
  vector[q] log_lik;
  for (n in 1:q) log_lik[n] = multi_normal_lpdf(y[n] | alpha[1:3]+u[n],vv);
}
