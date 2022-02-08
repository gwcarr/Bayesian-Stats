library('R2jags')
regdat <- read.table('BondNew.txt')
names(regdat)

# linear model
mdl <- "
  model {

    for (i in 1:32) {
      y[i] ~ dnorm(mu[i], 1/vr)
      mu[i] <- b0 + b1*x[i]
    }
    b0 ~ dnorm(0, 0.0001)
    b1 ~ dnorm(0, 0.0001)
    vr ~ dgamma(1.1, 0.1)
  }
"

writeLines(mdl, 'linreg.txt')

x <- regdat$CouponRate
y <- regdat$BidPrice

data.jags <- c('x', 'y')
parms <- c('b0', 'b1', 'vr')

linreg.sim <- jags(data=data.jags, inits = NULL, parameters.to.save = parms,
                   model.file = 'linreg.txt', n.iter = 10000, n.burnin = 1000,
                   n.chains = 4, n.thin = 3)

linreg.sim

sims <- as.mcmc(linreg.sim)
gelman.diag(sims)
chains <- as.matrix(sims)
sims <- as.mcmc(chains)
raftery.diag(sims)
effectiveSize(sims)
autocorr.diag(sims)
geweke.diag(sims)

chains[1,]
b0 <- chains[,1]
b1 <- chains[,2]
plot(density(b1))
