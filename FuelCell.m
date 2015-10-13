function [Xout,Nout, W_out, n_fuel,Eff_FC] = FuelCell(V_fc,Tdesign, TXNoxidant,TXfuel,S2Cdesign)
F = 96485;  

% Reactions occuring in SOFC %
h = enthalpy(Tdesign);
erxn2 = .6; % Water gas shift effectiveness of reaction
erxn3 = 1; % Steam reformation of methane effectiveness of reaction
hrxn1 = 2*h(5)-2*h(4)-h(7); %2H2 + O2 -->  2H2O
hrxn2 = h(3)+h(4)-h(2)-h(5); %CO + H20 --> CO2 + H2 
hrxn3 = 3*h(4)+h(2)-h(1)-h(5); %CH4+H2O --> CO + 3H2

I = 4*1000*F*(TXNoxidant(:,8).*TXNoxidant(:,9));  %SOFC current X # of Cells based on oxidant flow and 100% oxidant utilization
[~, H_Oxidant] = enthalpy(TXNoxidant(:,1),TXNoxidant(:,2:8),TXNoxidant(:,9));

%Initial Assumption for reformation
util = .70;
n_H2_theoretical = (I/(2*1000*F))/util;  %Hydrogen flow rate with 100% CH4 conversion
n_fuel = n_H2_theoretical/(4*TXfuel(:,2)+1*TXfuel(:,3)+1*TXfuel(:,5));
XanodeIn = [1/(S2Cdesign+1) 0 0 0 S2Cdesign/(S2Cdesign+1) 0 0];
NanodeIn = n_fuel*(S2Cdesign+1);
error = 1;
while abs(error) > .002

    n_H2_theoretical = (I/(2*1000*F))/util;  %Hydrogen flow rate with 100% CH4 conversion
    n_fuel = n_H2_theoretical/(4*TXfuel(:,2)+1*TXfuel(:,3)+1*TXfuel(:,5));
    
    [~,Hfuel] = enthalpy(TXfuel(:,1), TXfuel(:,2:8),n_fuel);
   



    R3 = (XanodeIn(:,1).*NanodeIn)*erxn3;
    R2 = (XanodeIn(:,2).*NanodeIn +R3)*erxn2;
    R1 =(I/(4000*F));

    Nout = NanodeIn + 2*R3;        %Total Nout of anode 

    Xout(:,1) = (XanodeIn(:,1)*NanodeIn - R3)/Nout;
    Xout(:,2) = (XanodeIn(:,2)*NanodeIn-R2+R3)/Nout;
    Xout(:,3) = (XanodeIn(:,3)*NanodeIn+R2)/Nout;                 %Mass balance
    Xout(:,4) = (XanodeIn(:,4)*NanodeIn-(2*R1)+R2+(3*R3))/Nout;
    Xout(:,5) = (XanodeIn(:,5)*NanodeIn-R2-(R3)+(2*R1))/Nout;
    Xout(:,6) = (XanodeIn(:,6)*NanodeIn)/Nout;
    Xout(:,7) = (XanodeIn(:,7)*NanodeIn)/Nout;
    
    [~,Hout] = enthalpy(Tdesign, Xout,Nout);
    
    
    H2Omakeup = n_fuel.*(TXfuel(:,2)+TXfuel(:,3)+TXfuel(:,4))*S2Cdesign-n_fuel.*TXfuel(:,6);
    
    RecircPerc = H2Omakeup/(Nout.*Xout(5));
    
    NanodeIn = n_fuel+Nout*RecircPerc;
    XanodeIn = (Xout*Nout*RecircPerc+TXfuel(:,2:8).*n_fuel)/NanodeIn;
    


    [~,H_recirc] =  enthalpy(Tdesign, Xout, Nout*RecircPerc);
    
    Qreform = hrxn2*R2+hrxn3*R3;
    Qgen = -hrxn1*R1- V_fc.*I/1000;

    %energy balance: Fuel in+ oxidant in+recirculation in - reforming cooling+Qgen - flow out
    Qimbalance = H_Oxidant+Hfuel+H_recirc-Qreform+Qgen-Hout;
    
    CH4error = Qimbalance/hrxn3;
    CH4eqivelant = I/(4000*F)/util;
    
    utilNew = util*(1-CH4error/CH4eqivelant);
    error = util-utilNew;
    util = utilNew;                                  %Updating util
end   


Nout = Nout*(1-RecircPerc);

W_out = V_fc.*(I/1000);          %Total power out based on Voltage and current
LHV = 754256;
Eff_FC = W_out/(n_fuel*LHV);









