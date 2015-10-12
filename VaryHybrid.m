Pr = linspace(1,15);
P_ratio = linspace(15,30);
V_fc = linspace(.7,1.15);

Efficiency = zeros(100,1);
W_net = Efficiency;
W_fc = W_net;
W_gt = W_net;
T_out = W_net;
N_out = W_net

TXNin(:,1) = 300;
TXNin(:,2:8) = [0 0 0 0 0 .79 .21];
TXNin(:,9) = .5;



[Efficiency, W_net,W_fc,W_gt, T_out, X8,N_out] = hybrid(TXNin, Pr, P_ratio, 1200,V_fc);

