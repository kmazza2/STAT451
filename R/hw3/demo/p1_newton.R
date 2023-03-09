d1 <- function (param, data) {
	d11 <- 0
	d12 <- 0
	for(i in seq(dim(data)[1])) {
		a1 <- param[1]
		a2 <- param[2]
		ni <- data$spills[i]
		bi1 <- data$importexport[i]
		bi2 <- data$domestic[i]
		d11 <- d11 + bi1 * (ni * (a1 * bi1 + a2 * bi2)^(-1) - 1)
		d12 <- d12 + bi2 * (ni * (a1 * bi1 + a2 * bi2)^(-1) - 1)
	}
	return(matrix(c(d11, d12)))
}

d2 <- function (param, data) {

	d211 <- 0
	d221 <- 0
	d222 <- 0
	for(i in seq(dim(data)[1])) {
		a1 <- param[1]
		a2 <- param[2]
		ni <- data$spills[i]
		bi1 <- data$importexport[i]
		bi2 <- data$domestic[i]
		d211 <- d211 + bi1^2 * ni * (a1 * bi1 + a2 * bi2)^(-2)
		d221 <- d221 + bi1 * bi2 * ni * (a1 * bi1 + a2 * bi2)^(-2)
		d222 <- d222 + bi2^2 * ni * (a1 * bi1 + a2 * bi2)^(-2)
	}
	d211 <- (-1) * d211
	d221 <- (-1) * d221
	d222 <- (-1) * d222
	return(matrix(c(d211, d221, d221, d222),nrow=2))
}

result <- newton("data/oilspills.dat", "data/oilspillsparam.dat", d1, d2, 100, 0.01)
print(result)
