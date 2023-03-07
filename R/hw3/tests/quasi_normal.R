library(hw3)
d1 <- function (param, data) {
	data <- as.matrix(data)
	return(matrix(c(
		param[2]^(-1)*(sum(data) - length(data)*param[1]),
		param[2]^(-2)*((1/2)*sum((data-param[1])^2))-
			(length(data)/2)*(param[2]^(-1))
	)))
}
I <- function (param, data) {
	data <- as.matrix(data)
	return(matrix(c(
		param[2]^(-1)*length(data),
		0,
		0,
		(length(data)/2)*param[2]^(-2)
	), nrow=2))
}
# Expect quasi to raise exception
tryCatch(
	quasi("data/normal_data", "data/normal_param", d1, I, 100, 0.01),
	error=function(e) { quit(status=0) }
)
