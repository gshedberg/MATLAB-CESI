Pr = linspace(5,15)'; % Compressor pressure ratio
P_ITMperm = linspace(50,50)'; %ITM back pressure in kPa
V_fc = linspace(.7,1.15)'; %Fuel cell voltage

TXNin = zeros(100,9);
TXNin(:,1) = 300;
Xin = [0 0 0 0 0 .79 .21];
for i =1:1:7
    TXNin(:,i+1) = Xin(i);
end
TXNin(:,9) = .5;



[Efficiency, W_net,W_fc,W_gt, T_out, X8,N_out] = hybrid(TXNin, Pr, P_ITMperm, 1200,V_fc);

