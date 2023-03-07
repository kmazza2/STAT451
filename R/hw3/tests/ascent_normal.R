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
		- (length(data) / 2) * log(2 * pi) -
		length(data) * log(sqrt(param[2])) -
		(1/2) * param[2]^(-1) * sum((data - param[1])^2)
	)))
}
result <- ascent("data/normal_data", "data/normal_param", d1, ll, 100, 0.01)
stopifnot(
	result[1] == 1,
	abs(result[4] - (23)) < 5,
        abs(result[5] - (189.2)) < 20
)
