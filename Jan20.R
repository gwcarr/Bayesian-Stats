library(R2jags)
dat4x4 <- read.table('4x4example.dat', header = TRUE)

mdl <- "
model {
  for (i in 1:32) {
    y[i] ~ dnorm(mu[tmt1[i],tmt2[i]],1/vr)
  }
  for (i in 1:4) {
  for (j in 1:4) {
    mu[i,j] ~ dnorm(0,0.01)
  }
  }
  vr ~ dgamma(3, .3)
}
"
writeLines(mdl, 'a4x4.txt')
y <- dat4x4$y
tmt1 <- dat4x4$tmt1
tmt2 <- dat4x4$tmt2
data.jags <- c('y', 'tmt1', 'tmt2')
parms <- c('mu', 'vr')

a4x4.sim <- jags(data = data.jags, inits = NULL, parameters.to.save = parms, model.file='a4x4.txt',
                 n.chains = 3, n.iter = 5000, n.burnin = 1000, n.thin = 4)

library(coda)
sims <- as.mcmc(a4x4.sim)

chains <- as.matrix(sims)

m44m42 <- chains[,17] - chains[,15]
mean(m44m42 >0)
