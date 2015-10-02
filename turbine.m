function [W_net,T4, N_out_net] = turbine(N_out, TIT, nt, Pr)
global Cv Cp F
oneVec = ones(1,length(Pr));
Cv  = .7180;
Cp = 1.0050;
gam = Cp/Cv;
F = 96485;
TITMat = TIT*oneVec;
T4s = Pr.^(-1+1/gam)*TITMat;
T4 = (T4s-TITMat).*nt+TITMat;
% Wt = mf_out*Cp*(TITMat-T4);
n_air_in = 2;
[Wc1,T_air,~] = compress(1,Pr,n_air_in);
[x_air,n_air_out,nO2] = ITM(30,15,n_air_in);
[Wc2,T2,~] = compress2(1,30,nO2);
[~,x_fuel,T_anode,~,n_fuel] = FuelCell(1.2,nO2,T2,800);
[~,T_air,~] = compress(1,Pr,n_air_out);
[T_out,~,~,~] = combust(x_air,n_air_out,T_air,T_anode,x_fuel,n_fuel); 
[~, H_air] = enthalpy(T_air, x_air, n_air_out);

[~,H_fuel] = enthalpy(T_out, x_fuel, n_fuel);

[~,~,~,H_out] = combust_mf(x_air,n_air_out,x_fuel,n_fuel,T_air,T_out,TIT);
Wt = N_out*((H_fuel+n_fuel)*(H_air-n_air_out))*((1+F)/90000)*H_out;
W_net = Wt-Wc1-Wc2;
N_out_net = N_out;
end
