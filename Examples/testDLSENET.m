clear all
close all
clc

m = 100;
noi = 0; %0.5;

u = -4*(rand(1,m)-1/2);

dgenfun = @(u) u.^2 + sin(2*pi*u);

y = dgenfun(u);
y = y + noi*randn(size(y));

net = feedforwardnet(10,'trainlm');
tpam = net.trainParam;
tpam.max_fail = 1e3;

[net, Temp, netPar, fun] = trainDLSE(u,y,10,'trainlm',tpam);

mse = immse(net(u),y);
fprintf('Mean square error = %f\n',mse);
fprintf('\n')

%%
options = optimoptions('fmincon','OptimalityTolerance', 1e-3,...
    'Display','none','SpecifyObjectiveGradient',true);

[xstar,ystar] = dlsea(netPar,zeros(1,1),[],[],[],[],-2,2,[],options);

imin = find(y == min(y));
fprintf('Exact minimum\n');
fprintf('argmin = %f\n',u(imin))
fprintf('min = %f\n',y(imin))
fprintf('\n')

fprintf('Approximated minimum\n');
fprintf('argmin = %f\n',xstar)
fprintf('min = %f\n',net(xstar))

%%
figure()
subplot(3,1,1)
p1 = plot(u,y,'r*');
uu = linspace(-2,2);

hold on
plot(uu,dgenfun(uu),'k--')
% plot(v, net(v), 'c', 'linewidth', 1.2)
rfun = @(x) (fun.convfun(x))+(fun.concfun(x));
p2 = plot(uu, rfun(uu), 'b');
legend([p1,p2],{'$y_i$','$d_T(x)$'},'interpreter','latex')
xlabel('$x$','interpreter','latex')

subplot(3,1,2)
plot(uu, fun.convfun(uu))
xlabel('$x$','interpreter','latex')
ylabel('$f$','interpreter','latex')

subplot(3,1,3)
plot(uu, -fun.concfun(uu))
xlabel('$x$','interpreter','latex')
ylabel('$f$','interpreter','latex')

% matlab2tikz('examp1.tex')