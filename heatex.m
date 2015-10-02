function [T_out] = heatex(TXNin)

Tin = TXNin(:,1);
Xout = TXNin(:,2:8);
Nout = TXNin(:,9);
[~,H4] = enthalpy(Tin,Xout,Nout); %Enthalpy coming in to Heat Exchanger


T_guess = 300;
T_error = 100;
while T_error > .1
    H_guess = enthalpy(T_guess, Xout, Nout);
    Cp = SpecHeat(T_guess, Xout);
    
    T_error = (H_guess - H4)/(Cp*Nout);
    T_out = T_guess+T_error;
end


