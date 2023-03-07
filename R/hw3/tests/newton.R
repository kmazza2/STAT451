library(hw3)
d1 <- function (param, data) { return(matrix(c(param[1]^(2)-1))) }
d2 <- function (param, data) { return(matrix(c(2*param[1]))) }
result <- newton("data/newton_data", "data/newton_param", d1, d2, 100, 0.01)
stopifnot(
	result[1] == 1,
	abs(result[4][1] - (-1)) < 0.1
)
