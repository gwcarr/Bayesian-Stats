# first rearrange data
# tmt 1, A no previous
# tmt 2  A, B previous
# tmt 3  B, no previous
# tmt 4  B, A previous
bio <- read.table('bioequivxover.dat',header=T)
first <- bio[,1:3]
second <- bio[,4:6]
tmt <- c(1,1,3,3,3,1,1,1,3,3,4,4,2,2,2,4,4,4,2,2)
names(first) <- c('Subject','Treatment','Response')
subj <- 1:10
second <- cbind(subj,second)
names(second) <- c('Subject','PrevTreatment','TMT','Response')
third <- rbind(first[,c(1,3)],second[,c(1,4)])
newdat <- cbind(third[,1],tmt,third[,2])
newframe <- as.data.frame(newdat)
names(newframe) <- c('Subj','tmt','resp')
newframe
# now for Jags code
library(R2jags)
mdl <-"
model {
  for (i in 1:20){
     resp[i] ~ dnorm(mu[i],1/s2error)
     mu[i] <- alpha[tmt[i]] + beta[subj[i]]
  }
      for (i in 1:4){
      alpha[i] ~ dnorm(0,.0001)
      }
      for (i in 1:10){
      beta[i] ~ dnorm(0,1/s2sub)
      }
    s2error ~ dunif(0,2)
    s2sub ~ dunif(0,2)
}
"
writeLines(mdl,'biox.txt')
tmt <- newframe$tmt
subj <- newframe$Subj
resp <- newframe$resp
data.jags <- c('tmt','subj','resp')
parms <- c('alpha','s2error','s2sub')
biox.sim <- jags(data=data.jags, inits=NULL, parameters.to.save=parms,
                 model.file='biox.txt',n.chains=4,n.burnin=2000,
                 n.iter=52000,n.thin=10)
biox.sim
library(coda)
sims <- as.mcmc(biox.sim)
gelman.diag(sims)
chains <- as.matrix(sims)
sims <- as.mcmc(chains)
raftery.diag(sims)
autocorr.diag(sims)
effectiveSize(sims)
chains[1,]
plot(chains[,7],type='l')
A <- chains[,1]
BA <- chains[,2]
B <- chains[,3]
AB <- chains[,4]
mean((BA-A)>0)
mean((AB-B>0))
mean(((BA+AB)/2 - (A+B)/2)>0)
