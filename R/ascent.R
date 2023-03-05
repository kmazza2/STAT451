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

d1 <- function (param, data) {
	N <- as.matrix(data[c('spills')])
	b <- as.matrix(data[c('importexport', 'domestic')])
	return(matrix(c(
		b[,1] %*% (N * (b %*% param)^(-1) - 1),
		b[,2] %*% (N * (b %*% param)^(-1) - 1)
	)))
}


data_path <- "../C/data/oilspills.dat"
param_path <- "../C/test/data/fakeoilspillsparam.dat"
max_iter <- 10000
epsabs <- 0.01

data <- read.table(data_path, header=TRUE, sep=" ")
param <- as.matrix(read.table(param_path, header=TRUE, sep=" "))
converged <- FALSE
for(iter in seq(max_iter)) {
	derivative <- d1(param, data)
	likelihood <- ll(param, data)
	while(!(all(derivative == 0))) {
		next_param <- param + derivative
		next_likelihood <- ll(next_param, data)
		if(next_likelihood > likelihood) {
			break
		}
		derivative <- derivative / 2
	}
	if(norm(next_param - param, type="F") < epsabs) {
		converged <- TRUE
		break
	}
	param <- next_param
}
cat("Converged: ", converged, "\nIterations: ", iter, "\nValue: ", next_param, "\n")
