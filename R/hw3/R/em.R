em <- function (data_path, param_path, expect, maxim, max_iter, epsabs) {
	data <- read.table(data_path, header=TRUE, sep=" ")
	param <- as.matrix(read.table(param_path, header=TRUE, sep=" "))
	converged <- FALSE
	start_time <- proc.time()
	for(iter in seq(max_iter)) {
		expectation <- expect(param, data)
		next_param <- maxim(param, data, expectation)
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
