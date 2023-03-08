library(hw3)

f <- function (r, t) {
	return(exp(-r*t))
}
fp <- function (r, t) {
	return(-exp(-r*t)*t)
}
g <- function (K, N0) {
	return(K-N0)
}
gp <- 1
h <- function (K, r, N0, t) {
	return(N0 + g(K, N0)*f(r, t))
}
j <- function (K, r, N0, t) {
	return(N0*K*(h(K, r, N0, t))^(-1))
}
hr <- function (K, r, N0, t) {
	return(g(K, N0)*fp(r, t))
}
jr <- function (K, r, N0, t) {
	return(-N0*K*(h(K, r, N0, t))^(-2)*hr(K, r, N0, t))
}
fpp <- function (r, t) {
	return(t^2*exp(-r*t))
}
hk <- function (K, r, N0, t) {
	return(f(r, t)*gp)
}
jk <- function (K, r, N0, t) {
	return(N0*((h(K, r, N0, t))^(-1)-K*(h(K, r, N0, t))^(-2)*hk(K, r, N0, t)))
}
gpp <- 0

d1 <- function (param, data) {
        t <- as.matrix(data[c('day')])
        N <- as.matrix(data[c('population')])
        N0 <- N[1]
        r <- param[1]   
        K <- param[2]   
        d11 <- 0        
        d12 <- 0                
        for(i in seq(dim(data)[1])) {
		Ni <- N[i]
		ti <- t[i]
                d11 <- d11 + 2*(Ni-j(K, r, N0, ti))*(g(K, N0)*fp(r, ti)*j(K, r, N0, ti))
                d12 <- d12 + 2*(Ni-j(K, r, N0, ti))*N0*((h(K, r, N0, ti))^(-1)-K*(h(K, r, N0, ti))^(-2)*f(r, ti)*gp)
        }               
        return(matrix(c(d11, d12)))
}

d2 <- function (param, data) {
        t <- as.matrix(data[c('day')])
        N <- as.matrix(data[c('population')])
        N0 <- N[1]
        r <- param[1]
        K <- param[2]
        d211 <- 0
        d212 <- 0
        d222 <- 0
	for(i in seq(dim(data)[1])) {
		Ni <- N[i]
		ti <- t[i]
		d211 <- d211 +
2*g(K, N0)*(-fp(r, ti)*j(K, r, N0, ti)*jr(K, r, N0, ti)+(Ni-j(K, r, N0, ti))*j(K, r, N0, ti)*fpp(r, ti)+(Ni-j(K, r, N0, ti))*fp(r, ti)*jr(K, r, N0, ti))
		d212 <- d212 +
2*N0*(-jr(K, r, N0, ti)*((h(K, r, N0, ti))^(-1)-K*(h(K, r, N0, ti))^(-2)*f(r, ti)*gp)+
(Ni-j(K, r, N0, ti))*(-(h(K, r, N0, ti))^(-2)*hr(K, r, N0, ti)-K*gp*(-2*(h(K, r, N0, ti))^(-3)*hr(K, r, N0, ti)+(h(K, r, N0, ti))^(-2)*fp(r, ti))))
		d222 <- d222 +
2*N0*(-jk(K, r, N0, ti)*((h(K, r, N0, ti))^(-1)-f(r, ti)*K*(h(K, r, N0, ti))^(-2)*gp)+
(Ni-j(K, r, N0, ti))*(-(h(K, r, N0, ti))^(-2)*hk(K, r, N0, ti)-f(r, ti)*((h(K, r, N0, ti))^(-2)*gp-2*K*gp*(h(K, r, N0, ti))^(-3)*hk(K, r, N0, ti)+K*(h(K, r, N0, ti))^(-2)*gpp)))
        }
        return(matrix(c(d211, d212, d212, d222), nrow=2))
}
result <- newton("../tests/data/beetles", "../tests/data/beetlesparam", d1, d2, 10000, 0.01)
stopifnot(
	result[1] == 1,
	abs(result[4] - (0.117958549704334)) < 0.5,
	abs(result[5] - (1.033515302810911e+03)) < 40
)
