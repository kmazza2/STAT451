gauss <- function (data_path, param_path, d1, point_res, max_iter, epsabs) {
	data <- read.table(data_path, header=TRUE, sep=" ")
	param <- as.matrix(read.table(param_path, header=TRUE, sep=" "))
	converged <- FALSE
	start_time <- proc.time()
	for(iter in seq(max_iter)) {
		A <- c()
		for(i in seq(data)) {
			A <- cbind(A, d1(param, data, i))
		} 
		A <- t(A)
		x <- point_res(param, data)
		h <- solve((t(A) %*% A), (t(A) %*% x))
		next_param <- param + h
		if(norm(next_param - param, type="F") < epsabs) {
			converged <- TRUE
			break
		}
		param <- next_param
	}
	end_time <- proc.time()
	return(
		c(
			converged=converged,
			iter=iter,
			time=(end_time - start_time)[3],
			param=next_param
		)
	)
}
