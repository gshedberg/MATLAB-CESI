function [Efficiency, W_net,W_fc,W_gt, T_out, X8,N_out] = hybrid(TXNin, Pr, P_ratio, TIT,V_fc)
global  R F Na e 
R = 8.314;
Na = 6.022*10^23;
e = 1.602 * 10^-19;
F = 96485; 
TurbEff = .87;
CompEff = .82;

T1 = TXNin(:,1);  %Initial conditions into hybrid
X1 = TXNin(:,2:8);
N1 = TXNin(:,9);
Pin = 101;
LHVfuel = 8e5; %Lower heating value of CH4

[Wc1, T2 ,X2,N2, P2] = compress([T1,X1,N1], CompEff, Pr, Pin);

[T7, X7, N7, N3, T3] = ITM([T2',X2,N2], P2, P_ratio);

X3= [0 0 0 0 0 0 1];
P3=P2./P_ratio;
Pr2 = (Pr*Pin+25)./P3;
T4 = 300;

X4 = X3;
N4 = N3;
[~,H3] = enthalpy(T3,X3,N3);
[~,H4] = enthalpy(T4,X4,N4);
Q34 = H3-H4;

[Wc2, T5, X5, N5, P5] = compress([T4, X4, N4], CompEff, Pr2, P3);

T6 = 1023;

[X6,N6, W_fc, FC_fuel, Eff_FC] = FuelCell(V_fc,T6, [T5',X5,N5], [300,1 0 0 0 0 0 0 0],2);

LHVanode = 38917.23;

[X8, CombustFuel, N8, T8] = combust_mf([T7',X7,N7], [T6,X6,N6], TIT);

[Wt,T_out, N_out] = turbine([T8,X8,N8], TurbEff, 1./Pr);
W_gt = Wt-Wc1-Wc2;
Eff_GT = W_gt/((N6*LHVanode)+(CombustFuel*LHVfuel));
W_net = W_fc + W_gt;
% Q_CH4 = 8e5; %kJ/kmol of CH4
LHVcombust = 0;
% Efficiency = W_net/((N6*LHVfuel)+(N8*LHVcombust));
Efficiency = W_net/((FC_fuel+CombustFuel)*LHVfuel);
end