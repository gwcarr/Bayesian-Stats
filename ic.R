linreg <- read.table("BondNew.txt",header=TRUE)
x <- linreg$CouponRate
y <- linreg$BidPrice
N <- length(y)
linreg_dat <- list(N=N,y=y,x=x)
library(rstan)
options(mc.cores = parallel::detectCores())
fitic <- stan(file = 'ic.stan', data = linreg_dat, 
            iter = 9000, warmup=1000, thin = 2, chains = 4)
LLa <- as.array(fitic,pars='log_lik')
library(loo)
waic(LLa)
loo1 <- loo(fitic,pars='log_lik')
loo1
waic(fitic)
pareto_k_ids(loo1)
pareto_k_values(loo1)
pareto_k_influence_values(loo1)
pareto_k_table(loo1)
