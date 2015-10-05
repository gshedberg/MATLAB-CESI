function [Wc, T_out, X_out, N_out, P5] = compress2(TXNin, nc, Pr, Pin)
global Cv Cp

Cv  = .7180;
Cp = 1.0050;
gam = Cp/Cv;

Tin = TXNin(:,1); %New temp in from Heat Exchange
X_out = TXNin(:,2:8); %Composition of O2 from ITM
N_out = TXNin(:,9);     %Flow rate O2 from ITM
P5 = Pin*Pr;
[~,H4] = enthalpy(Tin, X_out, N_out); %Enthalpy coming in
T5s = Pr.^(1-1/gam)*Tin;                %Isentropic Temperature
[~,H5s] = enthalpy(T5s,X_out,N_out);    %Isentropic ENthalpy

H5 = (H5s-H4)/(nc+H4);              %Actual Enthalpy leaving compress2

T_guess = 800;
T_error = 100;

while abs(T_error) > .1
    [~,H_guess] = enthalpy(T_guess, Xout, Nout);
    T_error = (H5 - H_guess)/(Cp*Nout);
    T_out = T_guess + T_error; %Reiteration to calculate temperature out
end

Wc = Nout*Cp*(T_out-T1); %power taken for compression
end

 
