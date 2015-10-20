Pr = linspace(5,15)'; % Compressor pressure ratio
P_ITMperm = linspace(50,50)'; %ITM back pressure in kPa
V_fc = linspace(.9,.9)'; %Fuel cell voltage


% Pr = 15; % Compressor pressure ratio
% P_ITMperm = 50; %ITM back pressure in kPa
% V_fc = .9;
vectorLength = max([length(Pr), length(P_ITMperm),length(V_fc)]);

TXNin = zeros(vectorLength,9);
TXNin(:,1) = 300;
Xin = [0 0 0 0 0 .79 .21];
for i =1:1:7
    TXNin(:,i+1) = Xin(i);
end
TXNin(:,9) = .5;



[Efficiency,Eff_FC,Eff_GT,W_net,W_fc,W_gt,T_out,X8,N_out] = hybrid(TXNin, Pr, P_ITMperm, 1200,V_fc);


% Efficiency = Efficiency

figure(1)
plot(Pr,W_net,'m--')
ylabel('Power of Hybrid')
xlabel('Pressure Ratio')


figure(2)
plot(Pr,W_fc,'g--')
ylabel('Power of Fuel Cell')
xlabel('Pressure Ratio')

figure(3)
plot(Pr,W_gt,'r--')
ylabel('Power of Gas Turbine')
xlabel('Pressure Ratio')

figure(4)
hold off
plot(Pr,Efficiency,'m--')
ylabel('Efficiency of Hybrid')
xlabel('Pressure Ratio')
hold on

% figure(5)
plot(Pr,Eff_FC,'g-.')
% ylabel('Efficiency of Fuel Cell')
% xlabel('Pressure Ratio')

% figure(6)
plot(Pr,Eff_GT,'r-')
% ylabel('Efficiency of Gas Turbine')
% xlabel('Pressure Ratio')