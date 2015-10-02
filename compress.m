function [Wc, T2, P2] = compress(nc, Pr, n_air)
global Cv Cp
oneVec = ones(1,length(Pr));
Cv  = .7180;
Cp = 1.0050;
gam = Cp/Cv;
P1 = 1;
T1 = 300;
PrMat = Pr.*oneVec;
P2 = PrMat*P1;
T2s = PrMat.^(1-1/gam)*T1;
T2 = (T2s-T1)/nc+T1;
Wc = n_air*Cp*(T2-T1);
end
