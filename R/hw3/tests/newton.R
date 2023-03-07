library(hw3)
cat(getwd())
d1 <- function (param, data) { return(matrix(c(-2*param[1], -2*param[2]))) }
d2 <- function (param, data) { return(matrix(c(-2, 0, 0, -2), nrow=2)) }
result <- newton("data/newton_data", "data/newton_param", d1, d2, 100, 0.01)
stopifnot(result[1] == 1, result[4] == 0, result[5] == 0)
