I <- function (param, data) {
	N <- as.matrix(data[c('spills')])
	b <- as.matrix(data[c('importexport', 'domestic')])
	result_11 <-
		t((b[,1])^2) %*%
		(
			((b %*% param)^(-2)) *
			exp(b %*% param)
		)
	result_12 <-
		t((b[,1]) * b[,2]) %*%
		(
			((b %*% param)^(-2)) *
			exp(b %*% param)
		)
	result_22 <-
		t((b[,2])^2) %*%
		(
			((b %*% param)^(-2)) *
			exp(b %*% param)
		)
	return(matrix(c(
		result_11, result_12,
		result_12, result_22
		), nrow=2)
	)
}

d1 <- function (param, data) {
	N <- as.matrix(data[c('spills')])
	b <- as.matrix(data[c('importexport', 'domestic')])
	return(matrix(c(
		b[,1] %*% (N * (b %*% param)^(-1) - 1),
		b[,2] %*% (N * (b %*% param)^(-1) - 1)
	)))
}

ll <- function (param, data) {
        N <- as.matrix(data[c('spills')])
        b <- as.matrix(data[c('importexport', 'domestic')])
        log_mean <- b %*% param
        if(any(log_mean <= 0)) {
                return (-Inf)
        } else {
                return(matrix(c(
                        (t(N) %*% log(log_mean)) -
                        param[1] * sum(b[,1]) -
                        param[2] * sum(b[,2])
        )))
        }
}

posdef <- function(X) {
	return(all(eigen(X, only.values=TRUE)$values > 0))
}
