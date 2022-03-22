library(R2jags)
mdl <- "

 model  {

           for (i in 1:8){
                 CHD[i] ~ dbin(p[i],nRisk[i])
			logit(p[i]) <- bint + bcat*cat[i] + bage*age[i] + becg*ecg[i]				  
                 }
       bint ~ dnorm(0,.1)
       bcat ~ dnorm(0,.1)
       bage ~ dnorm(0,.1)
       becg ~ dnorm(0,.1)
	
  }

"

writeLines(mdl,'logistic1.txt')

CHD <- chd[,1]
nRisk <- chd[,2]
tmt <- chd[,6]
cat <- chd[,3]
age <- chd[,4]
ecg <- chd[,5]

data.jags <- c('CHD','nRisk','cat','age','ecg')
parms <- c('bint','bcat','bage','becg','p')


logistic1.sim <- jags(data=data.jags,inits=NULL,parameters.to.save=parms,
	   model.file='logistic1.txt',n.iter=12000,n.burnin=2000,n.chains=8,
	   n.thin=10)
logistic1.sim

mdl <- "

 model  {

           for (i in 1:8){
                 CHD[i] ~ dbin(p[i],nRisk[i])
			logit(p[i]) <- bint + bcat*cat[i] + bage*age[i] + becg*ecg[i]	+
			     bca*cat[i]*age[i] + bce*cat[i]*ecg[i]+bae*age[i]*ecg[i]+
			     bcae*cat[i]*age[i]*ecg[i]
                 }
       bint ~ dnorm(0,.1)
       bcat ~ dnorm(0,.1)
       bage ~ dnorm(0,.1)
       becg ~ dnorm(0,.1)
       bca ~ dnorm(0,.1)
       bce ~ dnorm(0,.1)
       bae ~ dnorm(0,.1)
       bcae ~ dnorm(0,.1)
	
  }

"

writeLines(mdl,'logistic2.txt')

CHD <- chd[,1]
nRisk <- chd[,2]
tmt <- chd[,6]
cat <- chd[,3]
age <- chd[,4]
ecg <- chd[,5]

data.jags <- c('CHD','nRisk','cat','age','ecg')
parms <- c('bint','bcat','bage','becg','bca','bce','bae','bcae','p')


logistic2.sim <- jags(data=data.jags,inits=NULL,parameters.to.save=parms,
                      model.file='logistic2.txt',n.iter=12000,n.burnin=2000,n.chains=8,
                      n.thin=10)
logistic2.sim

