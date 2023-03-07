library(hw3)
d1 <- function (param, data) {
	data <- as.matrix(data)
	return(matrix(c(
		param[2]^(-1)*(sum(data) - length(data)*param[1]),
		param[2]^(-2)*((1/2)*sum((data-param[1])^2))-
			(length(data)/2)*(param[2]^(-1))
	)))
}
d2 <- function (param, data) {
	data <- as.matrix(data)
	return(matrix(c(
		-(param[2]^(-1))*length(data),
		(param[2]^(-2))*(length(data)*param[1]-sum(data)),
		-(param[2]^(-2))*(sum(data)-length(data)*param[1]),
		(param[2]^(-2))*(
			(length(data)/2)-
				(param[2]^(-1))*sum((data-param[1])^(2))
		)
	), nrow=2))
}
result <- newton("data/normal_data", "data/normal_param", d1, d2, 100, 0.01)
stopifnot(
	result[1] == 1,
	abs(result[4] - (23)) < 0.1,
	abs(result[5] - (189.2)) < 0.1
)
