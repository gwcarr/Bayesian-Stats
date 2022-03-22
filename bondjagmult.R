library(R2jags)
mdl <- "
model {
for (i in 1:7){
   y[i,1:3] ~ dmnorm(mu[i,1:3],tau[1:3,1:3])
   for (j in 1:3){
   mu[i,j] <- metal[tmt[i,j]] + ing[ming[i,j]]
   }
}
   for (i in 1:3){
     metal[i] ~ dnorm(70,.001)
   }
    for (i in 1:7){
      ing[i] ~ dnorm(0,1/s2ingot)
    } 
    s2error ~ dgamma(1.1,.05)
    s2ingot ~ dgamma(1.1,.05)
    for (i in 1:3){
       for (j in 1:3){
       vv[i,j] <- ifelse(i!=j,s2ingot,s2ingot+s2error)
       }
    }
    tau[1:3,1:3] <- inverse(vv[1:3,1:3])
}

"
writeLines(mdl,'multbond.txt')
y <- t(matrix(bond$pressure,3,7))
tmt <- t(matrix(bond$metn,3,7))
ming <- t(matrix(bond$ingot,3,7))
data.jags <- c('y','tmt','ming')
parms <- c('metal','ing','s2error','s2ingot')

bondmult.sim <- jags(data=data.jags,inits=NULL,parameters.to.save=parms,
                     model.file='multbond.txt',n.iter=5000,
                     n.burn=1000,n.chains=5,n.thin=1)
