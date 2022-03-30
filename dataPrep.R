situp <- read.table('situp.dat',header=TRUE)
cenPart <- situp[situp$situp.cen!=0,]
notCen <- situp[situp$situp.cen==0,]
# now run stan model
library(rstan)
options(mc.cores = parallel::detectCores())
Ntmts <- 8
dim(cenPart)
N_cen <- 45
dim(notCen)
N_notCen <- 115
cen_situps <- cenPart$situp.cen
not_cen_situps <- notCen$situps
uwmc <- cenPart$uwm
uwfc <- cenPart$uwf
hmc <- cenPart$hm
hfc <- cenPart$hf
owmc <- cenPart$owm
owfc <- cenPart$owf
omc <- cenPart$om
ofc <- cenPart$of
uwmnc <- notCen$uwm
uwfnc <- notCen$uwf
hmnc <- notCen$hm
hfnc <- notCen$hf
owmnc <- notCen$owm
owfnc <- notCen$owf
omnc <- notCen$om
ofnc <- notCen$of
situp_dat <- list(Ntmts = Ntmts,N_cen=N_cen,N_notCen=N_notCen,cen_situps=cen_situps,not_cen_situps=not_cen_situps,uwmc=uwmc,uwfc=uwfc,hmc=hmc,hfc=hfc,owmc=owmc,owfc=owfc,omc=omc,ofc=ofc,uwmnc=uwmnc,uwfnc=uwfnc,hmnc=hmnc,hfnc=hfnc,owmnc=owmnc,owfnc=owfnc,omnc=omnc,ofnc=ofnc)
situp_exp_fit <- stan(file='situp.stan',data=situp_dat,iter=40000,warmup=4000,thin=9,chains=4)

samps <- extract(situp_exp_fit)
names(samps)
summary(situp_exp_fit)
summary(situp_exp_fit,pars=c('theta'),probs=c(.025,.975))$summary


situp_gamma_fit <- stan(file='situpgamma.stan',data=situp_dat,iter=40000,warmup=4000,thin=9,chains=4)
summary(situp_gamma_fit,pars=c('theta'),probs=c(.025,.975))$summary
