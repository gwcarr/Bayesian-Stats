mice <- read.table('micesurvival.dat',header=T)
micenotcen <- mice[mice$censored==0,1:3]
micecen <- mice[mice$censored!=0,c(1,2,4)]
dim(micenotcen)
dim(micecen)
Nnotcen <- 65
Ncen <- 15
N <- 80
notcenTime <- micenotcen$time
cenTime <- micecen$censored
centmt1 <- ifelse(micecen$tmt==1,1,0)
centmt2 <- ifelse(micecen$tmt==2,1,0)
centmt3 <- ifelse(micecen$tmt==3,1,0)
centmt4 <- ifelse(micecen$tmt==4,1,0)
notcentmt1 <- ifelse(micenotcen$tmt==1,1,0)
notcentmt2 <- ifelse(micenotcen$tmt==2,1,0)
notcentmt3 <- ifelse(micenotcen$tmt==3,1,0)
notcentmt4 <- ifelse(micenotcen$tmt==4,1,0)
notcenttmt1
notcenTmt <- micenotcen$tmt
cenTmt <- micecen$tmt
Ntmts <- 4
centmtnum <- micecen$tmt
notcentmtnum <- micenotcen$tmt
mice_dat <- list(N=N,Ncen=Ncen,Nnotcen=Nnotcen,cenTime=cenTime,notcenTime=notcenTime,Ntmts=Ntmts,centmt1=centmt1,centmt2=centmt2,centmt3=centmt3,centmt4=centmt4,notcentmt1=notcentmt1,notcentmt2=notcentmt2,notcentmt3=notcentmt3,notcentmt4=notcentmt4)
library(rstan)
options(mc.cores = parallel::detectCores())
mice_fit <- stan(file='micegamma.stan',data=mice_dat,iter=52000,warmup=2000,thin=5,chains=5)
summary(mice_fit,pars=c('shape','rate','meansurv'),probs=c(.025,.975))$summary
samps <- extract(mice_fit)
names(samps)
shapeparms <- samps[[1]]
rateparm <- samps[[2]]
survtime <- samps[[3]]
LLmice <- samps[[4]]
dim(LLmice)
loglik <- apply(LLmice,1,sum)
library(loo)
waic(LLmice)
loo(mice_fit,pars='log_lik')
dic <- mean(-2*loglik) + var(-2*loglik)/2
dic
library(coda)
sims <- as.mcmc(cbind(shapeparms,rateparm,survtime))
raftery.diag(sims)
effectiveSize(sims)
autocorr.diag(sims)
#  evaluate treatments
t2_t1 <- survtime[,2]-survtime[,1]
t3_t1 <- survtime[,3]-survtime[,1]
t3_t2 <- survtime[,3]-survtime[,2]
t4_t1 <- survtime[,4]-survtime[,1]
t4_t2 <- survtime[,4]-survtime[,2]
t4_t3 <- survtime[,4]-survtime[,3]
mean(t2_t1>0)
mean(t3_t1>0)
mean(t3_t2>0)
mean(t4_t1>0)
mean(t4_t2>0)
mean(t4_t3>0)

