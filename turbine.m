function [Wt,T_guess, N_out] = turbine(TXNin, EffTurb, Pr)
global Cv Cp F

Cv  = .7180;
Cp = 1.0050;
gam = Cp/Cv;
F = 96485;
TIT = 1200;

Tin = TXNin(:,1);     %Temperature out of combustor
X_out = TXNin(:,2:8); %Composition coming out of combustor
N_out = TXNin(:,9);  %Flow rate coming out of combustor

T9s = Pr.^(-1+1/gam).*Tin;   %Isentropic Expansion Temperature

[~,H] = enthalpy(T9s, X_out, N_out);    %Isentropic enthaplpy out
[~, Hin] = enthalpy(Tin,X_out,N_out);   %Enthalpy in to turbine from combustor

% if Tin > TIT
%     T_g = 1000;
%     error = 100;
%     [~,H_g] = (T_g,X_out,N_out);
%     error = (H_g - Hin)/(Cp*N_out);
%     Tin = Tin + error;
% else
Hout = (H-Hin)/(EffTurb+Hin);           %Actual enthalpy out

T_guess = 500;
T_error = 100;
while T_error > .1      %Reiteration to calculate temperature out
    [~,H_guess] = enthalpy(T_guess, X_out, N_out);
    T_error = (H_guess - Hout)/(Cp*N_out);
    T_guess = T_guess + T_error; 
end

% Wt = N_out*((H_fuel+n_fuel)*(H_air-n_air_out))*((1+F)/90000)*H_out;

Wt = N_out *Cp*(Tin-T_guess);       %Isentropic expansion power generation
end

    
    




