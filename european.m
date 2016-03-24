%Question 1
function [stock,optionprice,delta,bond] = european(S0,r,h,u,d,T)
n = T/h+1;
p = (exp(r*h)-d)/(u-d);
delta = zeros(n);
bond = zeros(n);
optionprice = zeros(n);
stock = zeros(n);
for i = 1:n
    for j = 1:i
        stock(j,i) = S0*u^(i-j)*d^(j-1);
    end
end
optionprice(:,n) = payoff(stock(:,n));
for i = 1:n-1
    for j = 1:n-i
       optionprice(j,n-i) = (p*optionprice(j,n-i+1)+(1-p)*optionprice(j+1,n-i+1))*exp(-r*h);   
    end
end
for i = 1:n-1
    for j = 1:n-i
        delta(j,n-i) = (optionprice(j,n-i+1)-optionprice(j+1,n-i+1))/(stock(j,n-i+1)-stock(j+1,n-i+1));
        bond(j,n-i) = exp(-r*h)*(optionprice(j,n-i+1)-delta(j,n-i)*stock(j,n-i+1));
    end
end
stock
optionprice
delta
bond
end


function z = payoff(St)
n = size(St,1);
z = zeros(n,1);
K = 90;
for i = 1:n
    %straddle
    z(i) = max(St(i)-K,K-St(i));
    
    %Binary Call
    %z(i) = max((St(i)-K)/abs(St(i)-K),0);
end
end