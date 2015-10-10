function [Tout, Xair, Nout, NO2, TO2] = ITM(TXNin, P2, P_ratio)
global F 
F = 96400;
Ru = 8.314;
Tavg = (TXNin(1)+P_ratio.^(1-1/1.4).*TXNin(:,1))/2;
Cp = SpecHeat(Tavg, TXNin(2:8));
gam = Cp/(Cp-Ru);
T2 = TXNin(:,1);
Nin = TXNin(:,9);

x_feed =TXNin(:,2:8); %Feed composition from compressor
P_perm = P2*x_feed(7)/P_ratio; %permeate pressure (Air products)

[~,H2] = enthalpy(T2,x_feed,Nin);       %Enthalpy in from compressor

Rt = 1-(1-x_feed(7))*P_perm/(x_feed(7)*(P2-P_perm)); %Theoretcial O2 recovery (Air Prod)

Re = .5 * Rt; %(Actual O2 Recovery)

NO2 = Re*x_feed(7)*Nin; %Molar Flow O2

x_np = x_feed*(1-Re)./(1-Re*x_feed); %Composition of Non-Permeate

Xair = (x_np);

Nout = Nin-NO2; %Molar flow of Non-Permeate
Tout = TXNin(1);
TO2 = TXNin(1);

% T3s = ((P_ratio).^(-1+1/gam))*T2; %Isentropic Expansion through ITM
% 
% [~,H3s] = enthalpy(T3s, Xair, Nout); %Isentropic Enthalpy out 
% 
% H3 = (H3s-H2)/(Re+H2);      %actual enthalpy out

% T_guess = 700;
% T_error = 100;
% while abs(T_error) > .1
%     [~,H_guess] = enthalpy(T_guess, Xair, Nout);
%     T_error = (H3 - H_guess)/(Cp*Nout);
%     T_guess = T_guess + T_error; %Reiteration to calculate temperature out
% end
% XO2 = [0 0 0 0 0 0 1];
% T02 = 700;
% T_er = 100;
% while abs(T_er) > .1
%     [~,H_gu] = enthalpy(T02, XO2, NO2);
%     T_er = (H3 - H_gu)/(Cp*NO2);
%     TO2 = T02 + T_er; %Reiteration to calculate temperature out of O2
% end
end