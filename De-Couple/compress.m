function [Wc, T_guess  ,Xout,Nout, P2] = compress(TXNin, nc, Pr, Pin)
Ru = 8.314;
Tavg = (TXNin(1)+Pr.^(1-1/1.4).*TXNin(:,1))/2;
Cp = SpecHeat(Tavg, TXNin(2:8));
gam = Cp/(Cp-Ru);
T1 = TXNin(:,1); %Inlet Temp
Xout = TXNin(:,2:8); %Inlet Composition
Nout = TXNin(:,9); %Inlet Air Flow
P2 = Pin*Pr;
[~,H1] = enthalpy(T1, Xout,Nout); %Initial Enthalpy
T2s = Pr.^(1-1/gam).*T1; %Isnetropic Temperature Change
[~,H2s] = enthalpy(T2s, Xout,Nout); %Isentropic Enthalpy change

H2 = (H2s-H1)/nc+H1; %Actual Enthalpy change

T_guess = 800;
T_error = 100;
while abs(T_error) > .1
    [~,H_guess] = enthalpy(T_guess, Xout, Nout);
    T_error = (H2 - H_guess)/(Cp*Nout);
    T_guess  = T_guess + T_error; %Reiteration to calculate temperature out
end

Wc = H2 - H1; %power taken for compression

