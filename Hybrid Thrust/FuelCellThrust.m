function [Xout,Nout, W_out, n_fuel,Eff_FC] = FuelCellThrust(V_fc,Tdesign, TXNoxidant,TXfuel)

F = 96485;  
h = enthalpy(Tdesign);
erxn = .6;
hrxn1 = 2*h(:,5)-2*h(:,4)-h(:,7); %2H2 + O2 -->  2H2O
hrxn2 = h(:,3)+h(:,4)-h(:,2)-h(:,5); %CO + H20 --> CO2 + H2 

I = 4*1000*F*(TXNoxidant(:,8).*TXNoxidant(:,9));  %SOFC current X # of Cells based on oxidant flow and 100% oxidant utilization
[~, H_Oxidant] = enthalpy(TXNoxidant(:,1),TXNoxidant(:,2:8),TXNoxidant(:,9));

R2 = (XanodeIn(:,2).*NanodeIn +R3)*erxn2;
R1 =(I/(4000*F));

Nout = NanodeIn + 2*R3;        %Total Nout of anode 

Xout(:,1) = (XanodeIn(:,1).*NanodeIn - R3)./Nout;
Xout(:,2) = (XanodeIn(:,2).*NanodeIn-R2+R3)./Nout;
Xout(:,3) = (XanodeIn(:,3).*NanodeIn+R2)./Nout;                 %Mass balance
Xout(:,4) = (XanodeIn(:,4).*NanodeIn-(2*R1)+R2+(3*R3))./Nout;
Xout(:,5) = (XanodeIn(:,5).*NanodeIn-R2-(R3)+(2*R1))./Nout;
Xout(:,6) = (XanodeIn(:,6).*NanodeIn)./Nout;
Xout(:,7) = (XanodeIn(:,7).*NanodeIn)./Nout;

[~,Hout] = enthalpy(Tdesign, Xout,Nout);

