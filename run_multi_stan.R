y <- t(matrix(bond$pressure,3,7))
tmt <- t(matrix(bond$metn,3,7))
ming <- t(matrix(bond$ingot,3,7))
p <- 3
q <- 7
bond_mult_dat <- list(p=p,q=q,y=y,tmt=tmt,ming=ming)
library(rstan)
options(mc.cores = parallel::detectCores())
fit <- stan(file = 'multibond.stan', data = bond_mult_dat, 
            iter = 12000, warmup=2000, chains = 10, thin=5,control = list(adapt_delta = 0.999))
fit
LLa <- as.array(fit,pars='log_lik')
library(loo)
waic(LLa)
loo1 <- loo(fit,pars = 'log_lik')
loo1
