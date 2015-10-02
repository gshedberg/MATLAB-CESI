function [x_out, n_fuel, N_out, T_out] = combust_mf(x_air ,n_air, x_anode, n_anode, T_air, T_anode, TIT)

erxn1 = 1;
erxn2 = .7;
erxn3 = 1;

h = enthalpy(T_air+200);

% Reactions occuring in combustor %
hrxn1 = 2*h(5)+h(2)-h(1)-1.5*h(7); %Ch4 + 1.5 O2 --> CO + 2 H2O
hrxn2 = h(3)-h(2)-.5*h(7); %CO + .5 O2 --> CO2 
hrxn3 = h(5)-h(4)-.5*h(7); %H2 + .5 O2 -->  H2O


[T_noFuel, x_noFuel, N_noFuel] = combust(x_air,n_air, T_air, T_anode, x_anode, n_anode);

if T_noFuel<TIT
    Q_hv = 8e5;
    x_fuel = [1 0 0 0 0 0 0];
    T_fuel = 500;
    [~,H_TIT] = enthalpy(TIT, x_noFuel, N_noFuel);
    [~,H_noFuel] = enthalpy(T_noFuel, x_noFuel, N_noFuel);
    n_guess = (H_TIT-H_noFuel)/(Q_hv);
    error = 100;
    while abs(error)>.1
        R1 =(x_fuel(1)*n_guess)*erxn1;
        R2 =((x_fuel(2)*n_guess)+R1)*erxn2;
        R3 =(x_fuel(4)*n_guess)*erxn3;

        N_out = N_noFuel + n_guess + .5*R1 - .5*R2 - R3;

        x_out(1) = ((x_noFuel(1)*N_noFuel + x_fuel(1)*n_guess)-R1)/N_out;
        x_out(2) = ((x_noFuel(2)*N_noFuel + x_fuel(2)*n_guess)+R1-R2)/N_out;
        x_out(3) = ((x_noFuel(3)*N_noFuel + x_fuel(3)*n_guess)+(R2))/N_out;
        x_out(4) = ((x_noFuel(4)*N_noFuel + x_fuel(4)*n_guess)-R3)/N_out;
        x_out(5) = ((x_noFuel(5)*N_noFuel + x_fuel(5)*n_guess)+R3+(2*R1))/N_out;
        x_out(6) = ((x_noFuel(6)*N_noFuel + x_fuel(6)*n_guess))/N_out;
        x_out(7) = ((x_noFuel(7)*N_noFuel + x_fuel(7)*n_guess)-(1.5*R1)-(.5*R2)-(.5*R3))/N_out;
        
        [~,H_fuel] = enthalpy(T_fuel,x_fuel,n_guess);
        H_out = H_noFuel+H_fuel+(R1*hrxn1)+(R2*hrxn2)+(R3*hrxn3);
        
        T_out = TIT;
        T_error = 100;
        while abs(T_error) > .1
           [~,H_guess] = enthalpy(T_out, x_out, N_out);
           Cp = SpecHeat(T_out, x_out);

           T_error = (H_out-H_guess)/(Cp*N_out);
           T_out = T_out+T_error;
        end
        error = TIT- T_out;
        [~,H_TIT] = enthalpy(TIT,  x_out, N_out);
        n_guess = n_guess + (H_TIT-H_out)/Q_hv;
    end
end
n_fuel = n_guess;