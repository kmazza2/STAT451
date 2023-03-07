newton <- function (data_path, param_path, max_iter, epsabs) {
	data <- read.table(data_path, header=TRUE, sep=" ")
	param <- as.matrix(read.table(param_path, header=TRUE, sep=" "))
	converged <- FALSE
	start_time <- proc.time()
	for(iter in seq(max_iter)) {
		deriv1 <- d1(param, data)
		deriv2 <- d2(param, data)
		h <- solve((-1)*deriv2, deriv1)
		next_param <- param + h
		if(norm(next_param - param, type="F") < epsabs) {
			converged <- TRUE
			break
		}
		param <- next_param
	}
	end_time <- proc.time()
	cat(
		"Converged: ", converged,
		"\nIterations: ", iter,
		"\nTime: ", (end_time - start_time)[3],
		"s\nValue: ", next_param,
		"\n"
	)
}
