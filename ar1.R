library(R2jags)

mdl <- "

model{

	for (i in 1:57){
		y[i,1:7] ~ dmnorm(mu[i,1:7],tau[1:7,1:7]);
		for (j in 1:7){
		mu[i,j] <- b0[trt[i,j]] + b1[trt[i,j]]*tz[i,j];
		}
	}

	for (i in 1:3){
		b0[i] ~ dnorm(70,.001);
		b1[i] ~ dnorm(0,.001);
	}

	rho ~ dbeta(1,1);
	s2err ~ dunif(0,50);

	for (i in 1:7){
		for (j in 1:7){
		vv[i,j] <- s2err*rho^(abs(i-j));
		}
	}

	tau[1:7,1:7] <- inverse(vv[1:7,1:7])

}
"
writeLines(mdl,'ar1.txt')


tmtn <- weightnew[,9]
timez <- weightnew[,5]
resp <- weightnew[,4]

trt <- t(matrix(tmtn,7,57))
tz <- t(matrix(timez,7,57))
y <- t(matrix(resp,7,57))

data.jags <- c('y','trt','tz')
parms <- c('b0','b1','s2err','rho')



ar1.sim <- jags(data=data.jags,inits=NULL,parameters.to.save=parms,
                model.file='ar1.txt',
           n.iter=12000,n.burnin=2000,n.chains=4,n.thin=4)
ar1.sim			
sims <- as.mcmc(ar1.sim)
library(coda)
gelman.diag(sims)
chains <- as.matrix(sims)
sims <- as.mcmc(chains)
effectiveSize(sims)
raftery.diag(sims)
autocorr.diag(sims)
# new run
ar1.sim <- jags(data=data.jags,inits=NULL,parameters.to.save=parms,
                model.file='ar1.txt',
                n.iter=52000,n.burnin=2000,n.chains=4,n.thin=10)
ar1.sim			
sims <- as.mcmc(ar1.sim)
gelman.diag(sims)
chains <- as.matrix(sims)
sims <- as.mcmc(chains)
effectiveSize(sims)
raftery.diag(sims)
autocorr.diag(sims)
chains[1,]
# check random assignment of students by looking at b0.  Won't work unless
# starting time is time 0
b0c <- chains[,1]
b0r <- chains[,2]
b0w <- chains[,3]
plot(density(b0w-b0c))
mean((b0w-b0c)>0)
plot(density(b0w-b0r))
mean((b0w-b0r)>0)
# Which training regimine is better
b1c <- chains[,4]
b1r <- chains[,5]
b1w <- chains[,6]
plot(density(b1w-b1c))
mean(b1w-b1c>0)
plot(density(b1r-b1c))
mean(b1r-b1c>0)
plot(density(b1w-b1r))
mean((b1w-b1r)>0)
