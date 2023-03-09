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

ll <- function (param, data) {
	a1 <- param[1]
	a2 <- param[2]
	log_term <- 0
	for(i in seq(dim(data)[1])) {
		ni <- data$spills[i]
		bi1 <- data$importexport[i]
		bi2 <- data$domestic[i]
		if(a1 * bi1 + a2 * bi2 <= 0) {
			return(matrix(c(-Inf)))
		}
		log_term <- log_term + ni * log(a1 * bi1 + a2 * bi2)
	}
	return(matrix(c(
		log_term - a1 * sum(data$importexport) - a2 * sum(data$domestic)
	)))
}

result <- ascent("data/oilspills.dat", "data/oilspillsparam.dat", d1, ll, 100, 0.01)
print(result)
