function [T_out, x_out, N_out] = combust(x_air,n_air, T_air, T_fuel, x_fuel, n_fuel)

erxn1 = 1;
erxn2 = .7;
erxn3 = 1;

h = enthalpy(T_air+200);

%Reactions occuring in combustor%
hrxn1 = 2*h(5)+h(2)-h(1)-1.5*h(7); %Ch4 + 1.5 O2 --> CO + 2 H2O
hrxn2 = h(3)-h(2)-.5*h(7); %CO + .5 O2 --> CO2 
hrxn3 = h(5)-h(4)-.5*h(7); %H2 + .5 O2 -->  H2O

%Total Enthalpy of combustion%
R1 =(x_fuel(1)*(n_fuel)*erxn1);
R2 = (x_fuel(2)*(n_fuel)+R1)*erxn2;
R3 =(x_fuel(4)*(n_fuel))*erxn3;

N_out = (n_fuel + n_air + .5*R1 - .5*R2 - R3);

x_out(1) = ((x_fuel(1)*n_fuel + x_air(1)*n_air)-R1)/N_out;
x_out(2) = ((x_fuel(2)*n_fuel + x_air(2)*n_air)+R1-R2)/N_out;
x_out(3) = ((x_fuel(3)*n_fuel + x_air(3)*n_air)+(R2))/N_out;
x_out(4) = ((x_fuel(4)*n_fuel + x_air(4)*n_air)-R3)/N_out;
x_out(5) = ((x_fuel(5)*n_fuel + x_air(5)*n_air)+R3+(2*R1))/N_out;
x_out(6) = ((x_fuel(6)*n_fuel + x_air(6)*n_air))/N_out;
x_out(7) = ((x_fuel(7)*n_fuel + x_air(7)*n_air)-((1.5*R1)-(.5*R2)-(.5*R3)))/N_out;

[~,H_air] = enthalpy(T_air, x_air, n_air);
[~,H_fuel] =  enthalpy(T_fuel, x_fuel, n_fuel);

H_out = H_air + H_fuel+(R1*hrxn1)+(R2*hrxn2)+(R3*hrxn3);

T_out = 1000;
T_error = 100;
while abs(T_error) > 1
   [~,H_guess] = enthalpy(T_out, x_out, N_out);
   Cp = SpecHeat(T_out, x_out);

   T_error = (H_out-H_guess)/(Cp*N_out);
   T_out = T_out+T_error;
end





