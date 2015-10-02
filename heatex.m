function [T_out] = heatex(n_air, T_in)

[~,~,P2] = compress(1,30,.05);
[~, ~, ~, T_perm] = ITM(P2, 15, n_air);
x_in = [0 0 0 0 0 0 1];
H_out = n_air*(enthalpy(T_in) - enthalpy(T_perm));
T_guess = 300;
T_error = 100;
while T_error > .1
    H_guess = enthalpy(T_guess, x_in, n_air);
    Cp = SpecHeat(T_guess, x_in);
    
    T_error = (H_guess - H_out)/(Cp*n_air);
    T_out = T_guess+T_error;
end
T_out = sum(T_out(1:7)/7);



