function [Tout, Xair, Nout, NO2, TO2] = ITM(TXNin, P2, P_ratio)
global Cp Cv F 
F = 96400;
Cv = .7180;
Cp = 1.0050;
gam = Cp/Cv;
T2 = TXNin(:,1);
Nin = TXNin(:,9);
oneVec = ones(1,length(P2));
x_feed =TXNin(:,2:8); %Feed composition from compressor
P_perm = P2*x_feed(7)/P_ratio; %permeate pressure (Air products)

[~,H2] = enthalpy(T2,x_feed,Nin);

% P = P2/P_ratio;
% P_perm = (P_feed.*X_feed)/7;
Rt = 1-(1-x_feed(7))*P_perm/(x_feed(7)*(P2-P_perm)); %Theoretcial O2 recovery (Air Prod)

Re = .75 * Rt; %(Actual O2 Recovery)

NO2 = Re*x_feed(7)*Nin*.02897; %Molar Flow O2

x_np = x_feed*(1-Re)./(1-Re*x_feed); %Composition of Non-Permeate

Xair = (x_np);

Nout = ((1-Re)*(Xair(6))*Nin*(.02897))+((1-Re)*(Xair(7))*Nin*(.02897)); %Molar flow of Non-Permeate

T3s = ((1/P_ratio).^(1-gam))*T2; %Isentropic Expansion through ITM

[~,H3s] = enthalpy(T3s, Xair, Nout); %Isentropic Enthalpy

H3 = (H3s-H2)/(Re+H2);

T_guess = 700;
T_error = 100;
while abs(T_error) > .1
    [~,H_guess] = enthalpy(T_guess, Xair, Nout);
    T_error = (H3 - H_guess)/(Cp*Nout);
    Tout = T_guess + T_error; %Reiteration to calculate temperature out
end

T_gu = 700;
T_er = 100;
while abs(T_er) > .1
    [~,H_gu] = enthalpy(T_gu, XO2, NO2);
    T_er = (H3 - H_gu)/(Cp*NO2);
    TO2 = T_gu + T_er; %Reiteration to calculate temperature out of O2
end
end