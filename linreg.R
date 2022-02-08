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

