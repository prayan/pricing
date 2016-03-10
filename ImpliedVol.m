% Implied Volatility and Mean-Variance Portfolio Optimization

cd('~/Documents/OneDrive/Programming Workshop/solution5')
clear all
clc

optionprices = xlsread('OptionPrices.xlsx')

% set the parameters
S0    = 204.24;
T     = 30/252;
r     = .01;
sigma = .1220;

for i = 1:size(optionprices,1)
    K = optionprices(i,1);
    price = optionprices(i,2);
    myfunc = @(vol) abs(mybsprice(S0, K, r, T, vol)-price)
    implied_vol(i,:) = [fsolve(myfunc, 0.5) blsimpv(S0, K, r, T, price)];
end

out = [optionprices implied_vol]

% plot the curves on separate graphs
figure
subplot(2,1,1);
plot(out(:,1),out(:,3))
title('Yahoo Finance Implied Vol')
xlabel('Strike')
ylabel('Implied Volatility')

subplot(2,1,2);
plot(out(:,1),out(:,4))
title('Calculated Implied Vol')
xlabel('Strike')
ylabel('Implied Volatility')

% or plot them together
figure
plot(out(:,1),out(:,3),out(:,1),out(:,4))

title('Implied Volatilities')
legend('Yahoo Finance','Calculated')

% write the data 
xlswrite('optionprices_out.xlsx',out)

% part two
% read in the data
stocks = csvread('stockdata.csv');

rets = stocks(2:end,:)./stocks(1:end-1,:)-1;

Sigma = cov(rets);
mu = mean(rets,1)';

one   = ones( size(mu) );
invSigma = inv(Sigma);

A = mu' * invSigma * one;
B = mu' * invSigma * mu;
C = one' * invSigma * one;
D = B*C - A^2;

% minimize the variance such that the weights sum to 1
f = zeros( size(mu) );
weights1 = quadprog(Sigma,f,[],[],one',1) 

% verify that this equals the analytical formula
invSigma * one / C

mustar = .002;
weights2 = quadprog(Sigma,f,-mu',-mustar,one',1)

(B*invSigma*one - A*invSigma*mu + mustar*(C * invSigma * mu - A*invSigma*one))/D

% fit a model that constrains the weights to be positive
weights3 = quadprog(Sigma,f,-mu',-mustar,one',1, zeros( size(mu) ), one)

% fit a model that achieves a 10% monthly return with all weights in [0,1]
mustar2 = .01;
weights4 = quadprog(Sigma,f,-mu',-mustar2,one',1, zeros(size(mu)), one) 

