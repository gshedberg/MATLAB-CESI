% Pr = linspace(5,15)'; % Compressor pressure ratio
% P_ITMperm = linspace(50,50)'; %ITM back pressure in kPa
% V_fc = linspace(.7,1.15)'; %Fuel cell voltage


Pr = 15; % Compressor pressure ratio
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


onevec = ones(1,length(Efficiency));
Efficiency = Efficiency*onevec;

figure(1)

surf(Eff_FC,Eff_GT,Efficiency);
% hold off
% plot(Pr,Efficiency,'m--')
% hold on

ylabel('Efficiency of Fuel Cell')
xlabel('Efficiency of Gas Turbine')
zlabel('Efficiency of Hybrid')

% figure(2)
% % hold off
% plot(Pr,Eff_FC,'g--')
% % hold on
% 
% ylabel('Efficiency of Fuel Cell')
% xlabel('Pressure Ratio')
% 
% figure(3)
% % hold off
% plot(Pr,Eff_GT,'g--')
% % hold on
% 
% ylabel('Efficiency of Gas Turbine')
% xlabel('Pressure Ratio')

% figure(4)
% plot(Pr,N6,'r--')
% xlabel('Pressure Ratio')
% ylabel('Anode Exhaust')