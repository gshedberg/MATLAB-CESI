function [Efficiency, W_net,W_fc,W_gt, T4, x_net,N_net] = hybrid(Pr, P_ratio, TIT, n_air)
global Cv Cp R F Na e 
R = 8.314;
Na = 6.022*10^23;
e = 1.602 * 10^-19;
Cv  = .7180;
Cp = 1.0050;
F = 96485; 
TurbEff = .87;
CompEff = .82;

T1 = 300;
X1 = [0 0 0 0 0 .79 .21];
N1 = n_air;
[Wcomp,T2,X2,N2,P2] = compress([T1, X1, N1],1,Pr, 101.325);

[x_air,n_air_out,nO2, ~] = ITM(P2,P_ratio,n_air);

[~,T5,~] = compress2(1,30,nO2);

[N_out_fc,x_out_fc,T_anode,W_fc,FC_fuel] = FuelCell(1.2,nO2, T3,800);


[x_net,CombustFuel,N_out,T_out] = combust_mf(x_air,n_air_out,x_out_fc,N_out_fc,T2,T_anode,TIT);

[W_gt,T4,N_net] = turbine([T8, X8,N8],TurbEff,Pr);

W_net = W_fc + W_gt;
Q_CH4 = 8e5; %kJ/kmol of CH4
Efficiency = W_net/((FC_fuel+CombustFuel)*Q_CH4);
end