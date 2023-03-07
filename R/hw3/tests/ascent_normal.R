library(hw3)
d1 <- function (param, data) {
	data <- as.matrix(data)
	return(matrix(c(
		param[2]^(-1)*(sum(data) - length(data)*param[1]),
		param[2]^(-2)*((1/2)*sum((data-param[1])^2))-
			(length(data)/2)*(param[2]^(-1))
	)))
}
ll <- function (param, data) {
	data <- as.matrix(data)
	return(matrix(c(
		- (length(data) /2 ) -
		length(data) * log(sqrt(param[2])) -
		(1/2) * param[2]^(-1) * sum((data - param[1])^2)
	)))
}
result <- ascent("data/normal_data", "data/normal_param", d1, ll, 100, 0.01)
# Expect this algorithm not to converge
stopifnot(
	result[1] == 0
)
