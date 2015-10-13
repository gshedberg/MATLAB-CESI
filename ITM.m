function [Tout, Xair, Nout, NO2, TO2] = ITM(TXNin, P2, P_ratio)
global F 
F = 96400;
Ru = 8.314;
Tavg = (TXNin(:,1:100)+P_ratio.^(1-1/1.4).*TXNin(:,1:100))/2;
Cp = SpecHeat(Tavg, TXNin(:,2:8));
gam = Cp./(Cp-Ru);
T2 = TXNin(:,1:100);
Nin = TXNin(:,108);

x_feed =TXNin(:,101:107); %Feed composition from compressor

oneVec = ones(1,100);

X_feed = oneVec'*x_feed;

% trans = (P2'.*X_feed(:,7));

P_perm = ((P2'.*X_feed(:,7))'./P_ratio); %permeate pressure (Air products)

[~,H2] = enthalpy(T2,x_feed,Nin);       %Enthalpy in from compressor

Rt = (1-(1-X_feed(1,7)).*P_perm)./(X_feed(1,7).*(P2-P_perm)); %Theoretcial O2 recovery (Air Prod)

Re = .5 * Rt; %(Actual O2 Recovery)

NO2 = Re*X_feed(1,7)*Nin; %Molar Flow O2

x_np = x_feed'*(1-Re)./(1-Re'*x_feed)'; %Composition of Non-Permeate

Xair = (oneVec*x_np');

Nout = Nin-NO2; %Molar flow of Non-Permeate
Tout = TXNin(1);
TO2 = TXNin(1);

end