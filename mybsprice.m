% define a function which calculates the BS price
function [price] = mybsprice(S0, K, r, T, sigma) 
    d1 = (log(S0./K) + (r+sigma.^2/2).*T)./(sigma.*(T.^(1/2)));
    d2 = (log(S0./K) + (r-sigma.^2/2).*T)./(sigma.*(T.^(1/2)));

    price = S0 .* normcdf(d1) - exp(-r.*T) .* K .* normcdf(d2);
end
