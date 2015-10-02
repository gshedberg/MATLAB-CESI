function [Wc, T2, P2] = compress2(nc, Pr,n_air)
global Cv Cp
oneVec = ones(1,length(Pr));
Cv  = .7180;
Cp = 1.0050;
gam = Cp/Cv;
P1 = 1;
T_in = 300;
% [~,T1,~] = compress(nc, Pr, n_air);
[~,~,P_in] = compress(nc,Pr,n_air);
P_ratio = 15;
[~,~,nO2] = ITM(P_in,P_ratio,.005);
[Tex1] = heatex(nO2,T_in);
% [Tex2] = heatex2(nO2,T_in); 
PrMat = Pr'*oneVec;
P2 = PrMat'*P1;
T2s = PrMat.^(1-1/gam)*Tex1;
T2 = (T2s-Tex1)/nc+Tex1;
Wc = nO2*Cp*(T2-Tex1);
end
