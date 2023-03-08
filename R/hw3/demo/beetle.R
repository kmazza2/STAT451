d1 <- function (param, data) {
	t <- as.matrix(data[c('day')])
	N <- as.matrix(data[c('population')])
	N0 <- N[1]
	d11 <- 0
	d12 <- 0
	r <- param[1]
	K <- param[2]
	for(i in seq(param)) {
		fac1 <- exp(-r*t[i])
		fac2 <- N0 + (K - N0) * fac1
		fac3 <- N[i] - K * N0 * fac2^(-1)
		d11 <- d11 + 2*fac3*K*N0*(K-N0)*(-t[i])*fac1*fac2^(-2)
		d12 <- d12 + 2*fac3*N0*fac2^(-1)*(K*fac2^(-1)*fac1-1)
	}
	d11 <- (-1) * d11
	d12 <- (-1) * d12
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
	for(i in seq(param)) {
		fac1 <- exp(-r*t[i])
		fac2 <- N0 + (K - N0) * fac1
		fac3 <- N[i] - K * N0 * fac2^(-1)
		d211 <- d211 + 2*K*N0*(K-N0)*(-t[i])*(
			fac1*fac2^(-2)*K*N0*fac2^(-2)*(K-N0)*fac1*(-t[i]) +
			fac3*fac2^(-2)*fac1*(-t[i]) +
			fac3*fac1*(-2)*fac2^(-3)*(K-N0)*fac1*(-t[i])
		)
		d212 <- d212 + 2*N0*(-t[i])*fac1*(
			K*(K-N0)*fac2^(-2)*
				(-N0*(fac2^(-2)+K*(-1)*fac2^(-2)*fac1))+
			fac3*(K-N0)*fac2^(-2)+
			fac3*K*fac2^(-2)+
			fac3*K*(K-N0)*(-2)*fac2^(-3)*fac1
		)
		d222 <- d222 + 2*N0*(
			fac2^(-1)*(fac1*K*fac2^(-1)-1)*(
				-N0*(fac2^(-1)+K*(-1)*fac2^(-2)*fac1)
			)+
			fac3*(fac1*K*fac2^(-1)-1)*((-1)*fac2^(-2)*fac1)+
			fac3*fac2^(-1)*(fac1*(fac2^(-1)+K*(-1)*fac2^(-2)*fac1))
		)
	}
	d211 <- (-1) * d211
	d212 <- (-1) * d212
	d222 <- (-1) * d222
	return(matrix(c(d211, d212, d212, d222), nrow=2))
}
