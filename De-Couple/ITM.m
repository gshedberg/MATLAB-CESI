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

end