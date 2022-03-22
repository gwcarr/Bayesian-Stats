library(rstan)
N <- 21
p <- 3
q <- 7
ingot <- bond$ingot
metn <- bond$metn
pressure <- bond$pressure
bond_dat <- list(N=N,p=p,q=q,ingot=ingot,metn=metn,pressure=pressure)
fit3 <- stan(file = 'mixedmod.stan', data=bond_dat,iter=20000,warmup=5000,chains=5,thin=5,control = list(adapt_delta = 0.999))
fit3
pairs(fit3)
LLa <- as.array(fit3,pars='log_lik')
library(loo)
waic(LLa)
loo1 <- loo(fit3,pars = 'log_lik')
loo1
