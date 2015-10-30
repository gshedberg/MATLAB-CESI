% Pr = linspace(5,15)'; % Compressor pressure ratio
% P_ITMperm = linspace(50,50)'; %ITM back pressure in kPa
% V_fc = linspace(.9,.9)'; %Fuel cell voltage


Pr = 10; % Compressor pressure ratio
P_ITMperm = 50; %ITM back pressure in kPa
V_fc = .9;
vectorLength = max([length(Pr), length(P_ITMperm),length(V_fc)]);

TXNin = zeros(vectorLength,9);
TXNin(:,1) = 300;
Xin = [0 0 0 0 0 .79 .21];
for i =1:1:7
    TXNin(:,i+1) = Xin(i);
end
TXNin(:,9) = .5;

[Efficiency,Eff_FC,Eff_GT,W_net,W_fc,W_gt,T_out,X8,N_out] = hybrid(TXNin, Pr, P_ITMperm, 1200,V_fc);

figure(1)
title('Net Power Comparison')
[hAx,hLine1,hLine2] = plotyy(Pr,W_net,Pr,W_fc);
xlabel('Pressure Ratio')
ylabel(hAx(1),'Net Power of Hybrid') % left y-axis
ylabel(hAx(2),'Net Power of Fuel Cell') % left y-axis
hLine1.LineStyle = '--';
hLine2.LineStyle = ':';

figure(2)
[hAx,hLine1,hLine2] = plotyy(Pr,W_net,Pr,W_gt);
xlabel('Pressure Ratio')
ylabel(hAx(1),'Net Power of Hybrid')
ylabel(hAx(2),'Net Power of Gas Turbine') 
hLine1.LineStyle = '--';
hLine2.LineStyle = ':';

figure(3)
[hAx,hLine1,hLine2] = plotyy(Pr,Efficiency,Pr,Eff_FC);
xlabel('Pressure Ratio')
ylabel(hAx(1),'Efficiency of Hybrid')
ylabel(hAx(2),'Efficiency of Fuel Cell')
hLine1.LineStyle = '--';
hLine2.LineStyle = ':'; 

figure(4)
[hAx,hLine1,hLine2] = plotyy(Pr,Efficiency,Pr,Eff_GT);
xlabel('Pressure Ratio')
ylabel(hAx(1),'Efficiency of Hybrid')
ylabel(hAx(2),'Efficiency of Gas Turbine')
hLine1.LineStyle = '--';
hLine2.LineStyle = ':';

% one = ones(1,100);
% Efficiency = Efficiency*one;
% figure(5)
% surf(Eff_GT,Eff_FC,Efficiency)
