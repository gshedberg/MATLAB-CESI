function [Efficiency, W_net,W_fc,W_gt, T_out, X_out,N_out] = hybrid(TXNin, Pr ,Er, P_ratio, TIT)
global Cv Cp R F Na e 
R = 8.314;
Na = 6.022*10^23;
e = 1.602 * 10^-19;
Cv  = .7180;
Cp = 1.0050;
F = 96485; 
TurbEff = .87;
CompEff = .82;

T1 = TXNin(:,1);  %Initial conditions into hybrid
X1 = TXNin(:,2:8);
N1 = TXNin(:,9);
Pin = 101;
[Wc1, T2 ,X2,N2, P2] = compress([T1,X1,N1], CompEff, Pr, Pin);

[T7, X7, N7, NO2, TO2] = ITM([T2,X2,N2], P2, P_ratio);

XO2 = [0 0 0 0 0 1];

[Wc2, T5, X5, N5, ~] = compress2([TO2, XO2, NO2], CompEff, Pr, Pin);

[T6,X6,N6, W_fc, CombustFuel] = FuelCell(V_fc, [T5,X5,N5], Tfuel);

[X_out, FC_fuel, N8, T8] = combust_mf([T7,X7,N7], [T6,X6,N6], TIT);

[Wt,T_out, N_out] = turbine([T8,X_out,(N8+n_fuel)], TurbEff, Er);
W_gt = Wt-Wc1-Wc2;
W_net = W_fc + W_gt;
Q_CH4 = 8e5; %kJ/kmol of CH4
Efficiency = W_net/((FC_fuel+CombustFuel)*Q_CH4);
end