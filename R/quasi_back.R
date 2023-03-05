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


data_path <- "../C/data/oilspills.dat"
param_path <- "../C/test/data/fakeoilspillsparam.dat"
max_iter <- 10000
epsabs <- 0.01

data <- read.table(data_path, header=TRUE, sep=" ")
param <- as.matrix(read.table(param_path, header=TRUE, sep=" "))
converged <- FALSE
start_time <- proc.time()
M <- (-1) * I(param, data)
for(iter in seq(max_iter)) {
	next_param <- param + solve((-1) * M, d1(param, data))
	if(norm(next_param - param, type="F") < epsabs) {
		converged <- TRUE
		break
	}
	# otherwise, update M
	y <- d1(next_param, data) - d1(param, data)
	z <- next_param - param
	v <- y - M %*% z
	c_recip <- (t(v) %*% z)
	# if c_recip is 0, don't change M
	if(c_recip != 0) {
		c <- 1 / c_recip
		candidate <- M + c[1]  * (v %*% t(v))
		while(c > 0 && !posdef(candidate)) {
			c <- c / 2
			candidate <- M + c[1]  * (v %*% t(v))
		}
		if(c > 0) {
			M <- candidate
		}
	}
	# and set param to next_param
	param <- next_param
}
end_time <- proc.time()
cat("Converged: ", converged, "\nIterations: ", iter, "\nTime: ", (end_time - start_time)[3], "s\nValue: ", next_param, "\n")
