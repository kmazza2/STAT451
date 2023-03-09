d1 <- function (param, data, i) {
        t <- as.matrix(data[c('day')])
        N <- as.matrix(data[c('population')])
        N0 <- N[1]
        r <- param[1]   
        K <- param[2]   
	Ni <- N[i]
	ti <- t[i]
        d11 <- K*N0*(K-N0)*ti*exp(-r*ti)*(N0+(K-N0)*exp(-r*ti))^(-2)
        d12 <- N0*((N0+(K-N0)*exp(-r*ti))^(-1)-K*(N0+(K-N0)*exp(-r*ti))^(-2)*exp(-r*ti))
        return(matrix(c(d11, d12)))
}

point_res <- function (param, data) {
        t <- as.matrix(data[c('day')])
        N <- as.matrix(data[c('population')])
        N0 <- N[1]
        r <- param[1]
        K <- param[2]
	A <- c()
	for(i in seq(dim(data)[1])) {
		yi <- N[i]
		f <- K*N0*(N0+(K-N0)*exp(-r*t[i]))^(-1)
		A <- c(A, yi - f)
	}
        return(as.matrix(A))
}
result <- gauss("data/beetles.dat", "data/beetlesparam.dat", d1, point_res, 100, 0.01)
print(result)
