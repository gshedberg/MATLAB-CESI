function [N_out, x_out, T_anode, W_out,n_CH4] = FuelCell(V_fc, nO2,T_air, T_fuel)
global R Na e Cv Cp F;
R = 8.314;
Na = 6.022*10^23;
e = 1.602 * 10^-19;
Cv  = .7180;
Cp = 1.0050;
F = 96485;  

n = 4;
erxn1 = 1;
erxn2 = .6;
erxn3 = .99;


h = enthalpy(1200);
util = .70;
% Reactions occuring in SOFC %
hrxn1 = 2*h(5)-2*h(4)-h(7); %2H2 + O2 -->  2H2O
hrxn2 = h(3)+h(4)-h(2)-h(5); %CO + H20 --> CO2 + H2 
hrxn3 = 3*h(4)+h(2)-h(1)-h(5); %CH4+H2O --> CO + 3H2


x_fuel = [.33 0 0 0 .66 0 0];

i = 4*1000*F*nO2;
n_ac = (i/(2*1000*F));
n_H2 = n_ac/util;
n_fuel = (3/4*n_H2);
n_CH4 = n_fuel*(x_fuel(1));


    
R3 = ((x_fuel(1)*n_fuel))*erxn3;
R2 = (x_fuel(2)*(n_fuel)+R3)*erxn2;
R1 =(i/(4000*F))*erxn1;

N_out = n_fuel + nO2 - R1 + 2*R3;

x_out(1) = (x_fuel(1)*n_fuel -R3)/N_out;
x_out(2) = ((x_fuel(2)*n_fuel  )-R2+R3)/N_out;
x_out(3) = ((x_fuel(3)*n_fuel )+R2)/N_out;
x_out(4) = ((x_fuel(4)*n_fuel )-(2*R1)+R2+(3*R3))/N_out;
x_out(5) = ((x_fuel(5)*n_fuel )-R2-(R3)+(2*R1))/N_out;
x_out(6) = ((x_fuel(6)*n_fuel ))/N_out;
x_out(7) = ((x_fuel(7)*n_fuel + nO2)-R1)/N_out;




[~,H_air] = enthalpy(T_air, [0 0 0 0 0 0 1], nO2);
[~,H_fuel] =  enthalpy(T_fuel, x_fuel, n_fuel);

W_out = V_fc*(i/1000);
H_out = H_fuel+H_air-(R3*hrxn3)- W_out -(R1*hrxn1)-(R2*hrxn2);

T_anode = 1200;
T_error = 100;
while T_error > .1
   H_guess = enthalpy(T_anode, x_out, N_out);
   Cp = SpecHeat(T_anode, x_out);

   T_error = (H_out-H_guess)/(Cp*N_out);
   T_anode = T_anode+T_error;
end









