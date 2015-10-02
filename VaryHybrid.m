Pr = linspace(3,30);
P_ratio = linspace(15,20);
TIT = 1200;
n_air = linspace(.25,5.25);

W_net = zeros(100,1);
W_fc = W_net;
W_gt = W_fc;
N_net = W_fc;
H_out = W_fc;
x_net = W_fc;

for j = 1:3
    for i = 1:3
        [N_net(i,j), W_fc(i,j),W_gt, W_net(i,j), H_out(i,j),~,~] = hybrid(Pr(i), P_ratio(i), TIT, n_air(j));
    end
end


figure(1)
plot(Pr,W_net)
ylabel('PressureRatio')
xlabel('Net Power of FC-GT')

figure(2)
plot(Pr,W_fc)
ylabel('PressureRatio')
xlabel('Net Power of Fuel Cell')


figure(3)
plot(Pr,W_gt)
ylabel('PressureRatio')
xlabel('Net Power of GT')

figure(4)
plot(Pr,N_net)
ylabel('PressureRatio')
xlabel('Net Molar Flow')

figure(5)
plot(Pr,H_out)
ylabel('PressureRatio')
xlabel('Enthalpy out')
figure(2)

figure (6)
surf(Pr,n_air,W_net)
xlabel('PressureRatio')
ylabel('Mol/sec')
zlabel('Net Power Fc-GT')