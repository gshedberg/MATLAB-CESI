function [x_air, n_air_out, n02, T_out] = ITM(P2, P_ratio, n_air_in)
global R F Na
Na = 6.02e23;
R = 8.314;
F = 96400;
oneVec = ones(1,length(P2));
x_feed =[0 0 0 0 0 .79 .21];
P_perm = P2*x_feed(7)/P_ratio;
% P = P2/P_ratio;
% P_perm = (P_feed.*X_feed)/7;
Rt = 1-(1-x_feed(7))*P_perm/(x_feed(7)*(P2-P_perm));
Re = .75 * Rt;
n02 = Re*x_feed(7)*n_air_in*.02897;
x_np = x_feed*(1-Re)./(1-Re*x_feed);
x_air = (x_np);
n_air_out = ((1-Re)*(x_air(6))*n_air_in*(.02897))+((1-Re)*(x_air(7))*n_air_in*(.02897));
[~,T_in,~] = compress(1,30,n_air_in);
T_out = T_in*(1/P_ratio)^(.4);
end