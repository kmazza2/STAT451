source("poiss.R")

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
