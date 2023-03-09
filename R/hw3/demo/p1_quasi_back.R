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

I <- function (param, data) {

	I11 <- 0
	I21 <- 0
	I22 <- 0
	for(i in seq(dim(data)[1])) {
		a1 <- param[1]
		a2 <- param[2]
		ni <- data$spills[i]
		bi1 <- data$importexport[i]
		bi2 <- data$domestic[i]
		I11 <- I11 +
			bi1^2 *
			(a1 * bi1 + a2 * bi2)^(-2) *
			exp(a1 * bi1 + a2 * bi2)
		I21 <- I21 +
			bi1 * bi2 *
			(a1 * bi1 + a2 * bi2)^(-2) *
			exp(a1 * bi1 + a2 * bi2)
		I22 <- I22 +
			bi2^2 *
			(a1 * bi1 + a2 * bi2)^(-2) *
			exp(a1 * bi1 + a2 * bi2)
	}
	return(matrix(c(I11, I21, I21, I22),nrow=2))
}

result <- quasi_back("data/oilspills.dat", "data/oilspillsparam.dat", d1, I, 100, 0.01)
print(result)
