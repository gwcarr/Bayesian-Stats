
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
  vector<lower=0>[Ntmts] alpha;
  real<lower=0> rate;
  }
transformed parameters{
  vector<lower=0>[Ntmts] theta;
  for (i in 1:Ntmts){
    theta[i] = alpha[i]/rate;
  }
}
model{
  for (i in 1:Ntmts){
    alpha[i] ~ gamma(1,1);
  }
  rate ~ gamma(1,1);
  target += gamma_lpdf(not_cen_situps | alpha[1]*uwmnc+alpha[2]*uwfnc+alpha[3]*hmnc+alpha[4]*hfnc+alpha[5]*owmnc+alpha[6]*owfnc+alpha[7]*omnc+alpha[8]*ofnc, rate);
  target += gamma_lccdf(cen_situps | alpha[1]*uwmc+alpha[2]*uwfc+alpha[3]*hmc+alpha[4]*hfc+
            alpha[5]*owmc+alpha[6]*owfc+alpha[7]*omc+alpha[8]*ofc, rate);
}


