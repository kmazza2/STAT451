expect <- function (param, data) {
	mu1 <- param[1]
	mu2 <- param[2]
	mu3 <- param[3]
	s11 <- param[4]
	s21 <- param[5]
	s22 <- param[6]
	s31 <- param[7]
	s32 <- param[8]
	s33 <- param[9]
	s <- rep(0, 9)
	for(i in seq(dim(data)[1])) {
		s[1] <- s[1] +
			if(is.na(data$x1[i])) {s11 + mu1^2}
			else {data$x1[i]^2} 
		s[2] <- s[2] +
			if(is.na(data$x2[i])) {s22 + mu2^2}
			else {data$x2[i]^2}
		s[3] <- s[3] +
			if(is.na(data$x3[i])) {s33 + mu3^2}
			else {data$x3[i]^2}
		s[4] <- s[4] +
			if(is.na(data$x1[i])) {
				if(is.na(data$x2[i])) {s21 + mu1 * mu2}
				else {mu1 * data$x2[i]}
			}
			else {
				if(is.na(data$x2[i])) {mu2 * data$x1[i]}
				else {data$x1[i] * data$x2[i]}
			}
		s[5] <- s[5] +
			if(is.na(data$x1[i])) {
				if(is.na(data$x3[i])) {s31 + mu1 * mu3}
				else {mu1 * data$x3[i]}
			}
			else {
				if(is.na(data$x3[i])) {mu3 * data$x1[i]}
				else {data$x1[i] * data$x3[i]}
			}
		s[6] <- s[6] +
			if(is.na(data$x2[i])) {
				if(is.na(data$x3[i])) {s32 + mu2 * mu3}
				else {mu2 * data$x3[i]}
			}
			else {
				if(is.na(data$x3[i])) {mu3 * data$x2[i]}
				else {data$x2[i] * data$x3[i]}
			}
		s[7] <- s[7] +
			if(is.na(data$x1[i])) {mu1}
			else {data$x1[i]}
		s[8] <- s[8] +
			if(is.na(data$x2[i])) {mu2}
			else {data$x2[i]}
		s[9] <- s[9] +
			if(is.na(data$x3[i])) {mu3}
			else {data$x3[i]}
	}
	return(as.matrix(s))
}

maxim <- function (param, data, expectation) {
	n <- dim(data)[1]
	mu1 <- expectation[7]/n
	mu2 <- expectation[8]/n
	mu3 <- expectation[9]/n
	s11 <- expectation[1]/n - mu1^2
	s21 <- expectation[4]/n - mu1 * mu2
	s22 <- expectation[2]/n - mu2^2
	s31 <- expectation[5]/n - mu1 * mu3
	s32 <- expectation[6]/n - mu2 * mu3
	s33 <- expectation[3]/n - mu3^2
	return(as.matrix(c(
		mu1,
		mu2,
		mu3,
		s11,
		s21,
		s22,
		s31,
		s32,
		s33
	)))
}
result <- em("data/trivariatenormal.dat", "data/trivariatenormalparam.dat", expect, maxim, 100, 0.01)
print(result)
