## Week 1 lab
## Wei Wei
## MFE Programming workshop 2015

## Function to get the Black-Scholes price of an option
myBSPrice <- function(s0,K,r,sigma,T) {
    d1 <- (log(s0/K)+(r+sigma^2/2)*T)/(sigma*sqrt(T))
    d2 <- (log(s0/K)+(r-sigma^2/2)*T)/(sigma*sqrt(T))

    ## pnorm is the CDF in R
    call_price <- s0*pnorm(d1)-exp(-r*T)*K*pnorm(d2)

    call_price
}

inT <- 1
inr <- .04
insigma <- .25
inK <- 95
ins0 <- 100

## make sure your parameters are in the right order
myBSPrice(ins0,inK,inr,insigma,inT)

## now do it for a set of K values
## note that were already vectorized!
Kvals <- 75:127
myBSPrice(ins0,Kvals,inr,insigma,inT)

## and on a grid of points
Tvals <- seq(1/12,2,by=1/12)

## this works for doing it across both sets of values. 
# sapply(X, FUN), X is vector or list, apply each row of X as argument into FUN
grid_results <- sapply(Tvals,
                       function(t) {
                           myBSPrice(ins0,Kvals,inr,insigma,t)
                       })

grid_results

