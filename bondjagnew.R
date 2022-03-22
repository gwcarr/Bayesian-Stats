library(R2jags)
mdl <- "
model {
for (i in 1:21){
   pressure[i] ~ dnorm(mu[i],1/s2error)
   mu[i] <- metal[metn[i]] + ing[ingot[i]]
}
   for (i in 1:3){
     metal[i] ~ dnorm(70,.001)
   }
    for (i in 1:7){
      ing[i] ~ dnorm(0,1/s2ingot)
    } 
    s2error ~ dgamma(1.1,.05)
    s2ingot ~ dgamma(1.1,.05)
}

"

writeLines(mdl,'bondmodel.txt')
metn <- bond$metn
pressure <- bond$pressure
ingot <- bond$ingot
data.jags <- c('metn','pressure','ingot')
parms <- c('metal','ing','s2error','s2ingot')
bond.sim <- jags(model.file='bondmodel.txt',data=data.jags,
                 parameters.to.save=parms,n.iter=26000,
                 n.burnin=1000,n.chains=5,n.thin=5,inits=NULL)
bond.sim
library(coda)
sims <- as.mcmc(bond.sim)
gelman.diag(sims)
chains <- as.matrix(sims)
sims <- as.mcmc(chains)
effectiveSize(sims)
autocorr.diag(sims)
raftery.diag(sims)
chains[1,]
icc <- chains[,13]/(chains[,12]+chains[,13])
plot(density(icc))
quantile(icc,c(.025,.975))
mean((chains[,4]-chains[,3])>0)
mean((chains[,10]-chains[,9])>0)   
mean((chains[,10]-chains[,11])>0) 
