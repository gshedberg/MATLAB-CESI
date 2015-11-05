Pr = linspace(5,25)'; % Compressor pressure ratio
P_ITMperm = linspace(50,50)'; %ITM back pressure in kPa
V_loss = linspace(.1501,.1501)'; %Fuel cell voltage
TIT = 1200;
% 
% Pr = 10; % Compressor pressure ratio
% P_ITMperm = 50; %ITM back pressure in kPa
% V_fc = .9;
vectorLength = max([length(Pr), length(P_ITMperm),length(V_loss)]);

TXNin = zeros(vectorLength,9);
TXNin(:,1) = 300;
Xin = [0 0 0 0 0 .79 .21];
for i =1:1:7
    TXNin(:,i+1) = Xin(i);
end
TXNin(:,9) = .013;

[Efficiency,Eff_FC,Eff_GT,W_net,W_fc,W_gt,T_out,X8,N_out,V_fc] = hybrid(TXNin, Pr, P_ITMperm, TIT,V_loss);

figure(1)
title('Net Power Comparison')

[hAx,hLine1,hLine2] = plotyy(Pr,W_net,Pr,W_fc);
xlabel('Pressure Ratio (Bar)')
ylabel(hAx(1),'Net Power of Hybrid') % left y-axis
ylabel(hAx(2),'Net Power of Fuel Cell') % left y-axis
hLine1.LineStyle = '--';
hLine2.LineStyle = ':';

figure(2)
[hAx,hLine1,hLine2] = plotyy(Pr,W_net,Pr,W_gt);
xlabel('Pressure Ratio (Bar)')
ylabel(hAx(1),'Net Power of Hybrid')
ylabel(hAx(2),'Net Power of Gas Turbine') 
hLine1.LineStyle = '--';
hLine2.LineStyle = ':';


figure(3)
[hAx,hLine1,hLine2] = plotyy(Pr,Efficiency,Pr,Eff_FC);
xlabel('Pressure Ratio (Bar)')
ylabel(hAx(1),'Efficiency of Hybrid')
ylabel(hAx(2),'Efficiency of Fuel Cell')
hLine1.LineStyle = '--';
hLine2.LineStyle = ':'; 

figure(4)
[hAx,hLine1,hLine2] = plotyy(Pr,Efficiency,Pr,Eff_GT);
xlabel('Pressure Ratio (Bar)')
ylabel(hAx(1),'Efficiency of Hybrid')
ylabel(hAx(2),'Efficiency of Gas Turbine')
hLine1.LineStyle = '--';
hLine2.LineStyle = ':';

% figure(5)
% [hAx,hLine1,hLine2] = plotyy(V_fc,Efficiency,V_fc,W_fc);
% xlabel('Fuel Cell Output Voltage')
% ylabel(hAx(1),'Efficiency')
% ylabel(hAx(2),'W_fc')
% hLine1.LineStyle = '--';
% hLine2.LineStyle = ':';
% 
