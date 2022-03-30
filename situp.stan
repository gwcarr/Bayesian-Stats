
data {
  int<lower=1> N_cen;
  int<lower=1> N_notCen;
  vector[N_cen] cen_situps;
  vector[N_notCen] not_cen_situps;
  int<lower=1> Ntmts;
  vector[N_cen] uwmc;
  vector[N_cen] uwfc;
  vector[N_cen] hmc;
  vector[N_cen] hfc;
  vector[N_cen] owmc;
  vector[N_cen] owfc;
  vector[N_cen] omc;
  vector[N_cen] ofc;  
  vector[N_notCen] uwmnc;
  vector[N_notCen] uwfnc;
  vector[N_notCen] hmnc;
  vector[N_notCen] hfnc;
  vector[N_notCen] owmnc;
  vector[N_notCen] owfnc;
  vector[N_notCen] omnc;
  vector[N_notCen] ofnc;  
} 
 parameters {
  vector<lower=0>[Ntmts] lambda;
}
transformed parameters{
  vector<lower=0>[Ntmts] theta;
  for (i in 1:Ntmts){
    theta[i] = 1/lambda[i];
  }
}
model{
  for (i in 1:Ntmts){
    lambda[i] ~ gamma(1,1);
  }
  target += exponential_lpdf(not_cen_situps | lambda[1]*uwmnc+lambda[2]*uwfnc+lambda[3]*hmnc+lambda[4]*hfnc+lambda[5]*owmnc+lambda[6]*owfnc+lambda[7]*omnc+lambda[8]*ofnc);
  target += exponential_lccdf(cen_situps | lambda[1]*uwmc+lambda[2]*uwfc+lambda[3]*hmc+lambda[4]*hfc+
            lambda[5]*owmc+lambda[6]*owfc+lambda[7]*omc+lambda[8]*ofc);
}


