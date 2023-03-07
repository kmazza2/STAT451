library(hw3)
d1 <- function (param, data) {
	data <- as.matrix(data);
	return(matrix(c(data[1]-param[1])))
}
I <- function (param, data) { return(matrix(c(1))) }
result <- quasi("data/quasi_data", "data/quasi_param", d1, I, 100, 0.01)
stopifnot(
	result[1] == 1,
	abs(result[4][1] - (99)) < 0.1
)
