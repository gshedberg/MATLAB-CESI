function [W_net,T4, N_out_net] = turbine(TXNin, EffTurb, Pr)
global Cv Cp F
oneVec = ones(1,length(Pr));
Cv  = .7180;
Cp = 1.0050;
gam = Cp/Cv;
F = 96485;

T4s = Pr.^(-1+1/gam)*TITMat;
T4 = (T4s-TITMat).*EffTurb+TITMat;

[~, Hin] = enthalpy(TXNin(1), TXNin(2:8),TXNin(9));
Wt = N_out*((H_fuel+n_fuel)*(H_air-n_air_out))*((1+F)/90000)*H_out;
W_net = Wt-Wc1-Wc2;
N_out_net = N_out;
end
