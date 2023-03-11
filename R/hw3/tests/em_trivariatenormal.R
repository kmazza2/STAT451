library(hw3)

ev <- function (v, u, w, param, data) {
	param_mu <- c(param[1], param[2], param[3])
	param_sigma <- matrix(c(
		param[4], param[5], param[7],
		param[5], param[6], param[8],
		param[7], param[8], param[9]
		), nrow=3)
	return(param_mu[v])
}
ev2 <- function (v, u, w, param, data) {
	param_mu <- c(param[1], param[2], param[3])
	param_sigma <- matrix(c(
		param[4], param[5], param[7],
		param[5], param[6], param[8],
		param[7], param[8], param[9]
		), nrow=3)
	return(param_sigma[v,v] + param_mu[v]^2)
}
evw <- function(v, u, w, param, data) {
	param_mu <- c(param[1], param[2], param[3])
	param_sigma <- matrix(c(
		param[4], param[5], param[7],
		param[5], param[6], param[8],
		param[7], param[8], param[9]
		), nrow=3)
	return(param_sigma[v,w] + param_mu[v] * param_mu[w])
}
ev_given_u <- function (v, u, w, x_iu, param, data) {
	param_mu <- c(param[1], param[2], param[3])
	param_sigma <- matrix(c(
		param[4], param[5], param[7],
		param[5], param[6], param[8],
		param[7], param[8], param[9]
		), nrow=3)
	return(
		param_mu[v] +
		param_sigma[v,u] * (param_sigma[u,u])^(-1) *
			(x_iu - param_mu[u])
	)
}
ev2_given_u <- function (v, u, w, x_iu, param, data) {
	param_mu <- c(param[1], param[2], param[3])
	param_sigma <- matrix(c(
		param[4], param[5], param[7],
		param[5], param[6], param[8],
		param[7], param[8], param[9]
		), nrow=3)
	return(
		param_sigma[v,v] -
		param_sigma[v,u]^2 * param_sigma[u,u]^(-1) +
		(
			param_mu[v] +
			param_sigma[v,u] * param_sigma[u,u]^(-1) *
				(x_iu - param_mu[u])
		)^2
	)
}
evw_given_u <- function (v, u, w, x_iu, param, data) {
	param_mu <- c(param[1], param[2], param[3])
	param_sigma <- matrix(c(
		param[4], param[5], param[7],
		param[5], param[6], param[8],
		param[7], param[8], param[9]
		), nrow=3)
	mu1 <- c(param_mu[v], param_mu[w])
	mu2 <-  param_mu[u]
	sigma11 <- matrix(c(
		param_sigma[v,v], param_sigma[w,v],
		param_sigma[v,w], param_sigma[w,w]
		), nrow=2)
	sigma12 <- matrix(c(param_sigma[v,u], param_sigma[w,u]), nrow=2)
	sigma21 <- t(sigma12)
	sigma22 <- param_sigma[u,u]
	return(
		(sigma11-sigma12%*%solve(sigma22)%*%sigma21)[1,2] +
		(mu1+sigma12%*%solve(sigma22)%*%(x_iu-mu2))[1] *
			(mu1+sigma12%*%solve(sigma22)%*%(x_iu-mu2))[2]
	)
}
ev_given_uw <- function (v, u, w, x_iu, x_iw, param, data) {
	param_mu <- c(param[1], param[2], param[3])
	param_sigma <- matrix(c(
		param[4], param[5], param[7],
		param[5], param[6], param[8],
		param[7], param[8], param[9]
		), nrow=3)
	sigma12 <- matrix(c(param_sigma[v,u], param_sigma[v,w]), nrow=1)
	sigma22 <- matrix(c(
		param_sigma[u,u],
		param_sigma[w,u],
		param_sigma[u,w],
		param_sigma[w,w]),
		nrow=2)
	x2 <- matrix(c(x_iu, x_iw), nrow=2)
	mu2 <- matrix(c(param_mu[u], param_mu[w]), nrow=2)
	return(
		param_mu[v] +
		sigma12 %*% solve(sigma22) %*% (x2 - mu2)
	)
}
ev2_given_uw <- function (v, u, w, x_iu, x_iw, param, data) {
	param_mu <- c(param[1], param[2], param[3])
	param_sigma <- matrix(c(
		param[4], param[5], param[7],
		param[5], param[6], param[8],
		param[7], param[8], param[9]
		), nrow=3)
	mu1 <- param_mu[v]
	sigma11 <- param_sigma[v,v]
	sigma12 <- matrix(c(param_sigma[v,u], param_sigma[v,w]), nrow=1)
	sigma22 <- matrix(c(
		param_sigma[u,u],
		param_sigma[w,u],
		param_sigma[u,w],
		param_sigma[w,w]),
		nrow=2)
	x2 <- matrix(c(x_iu, x_iw), nrow=2)
	mu2 <- matrix(c(param_mu[u], param_mu[w]), nrow=2)
	return(
		sigma11 -
		sigma12 %*% solve(sigma22) %*% t(sigma12) +
		(mu1 + sigma12 %*% solve(sigma22) %*% (x2 - mu2))^2
	)
}

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
			if(is.na(data$x1[i])) {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						ev2(1, 2, 3, param, data)
					}
					else {
						ev2_given_u(1, 3, 2, data$x3[i], param, data)
					}
				}
				else {
					if(is.na(data$x3[i])) {
						ev2_given_u(1, 2, 3, data$x2[i], param, data)
					}
					else {
						ev2_given_uw(1, 2, 3, data$x2[i], data$x3[i], param, data)
					}
				}
			}
			else {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						data$x1[i]^2
					}
					else {
						data$x1[i]^2
					}
				}
				else {
					if(is.na(data$x3[i])) {
						data$x1[i]^2
					}
					else {
						data$x1[i]^2
					}
				}
			}
		s[2] <- s[2] +
			if(is.na(data$x1[i])) {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						ev2(2, 1, 3, param, data)
					}
					else {
						ev2_given_u(2, 3, 1, data$x3[i], param, data)
					}
				}
				else {
					if(is.na(data$x3[i])) {
						data$x2[i]^2
					}
					else {
						data$x2[i]^2
					}
				}
			}
			else {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						ev2_given_u(2, 1, 3, data$x1[i], param, data)
					}
					else {
						ev2_given_uw(2, 1, 3, data$x1[i], data$x3[i], param, data)
					}
				}
				else {
					if(is.na(data$x3[i])) {
						data$x2[i]^2
					}
					else {
						data$x2[i]^2
					}
				}
			}
		s[3] <- s[3] +
			if(is.na(data$x1[i])) {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						ev2(3, 1, 2, param, data)
					}
					else {
						data$x3[i]^2
					}
				}
				else {
					if(is.na(data$x3[i])) {
						ev2_given_u(3, 2, 1, data$x2[i], param, data)
					}
					else {
						data$x3[i]^2
					}
				}
			}
			else {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						ev2_given_u(3, 1, 2, data$x1[i], param, data)
					}
					else {
						data$x3[i]^2
					}
				}
				else {
					if(is.na(data$x3[i])) {
						ev2_given_uw(3, 1, 2, data$x1[i], data$x2[i], param, data)
					}
					else {
						data$x3[i]^2
					}
				}
			}
		s[4] <- s[4] +
			if(is.na(data$x1[i])) {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						evw(1, 3, 2, param, data)
					}
					else {
						evw_given_u(1, 3, 2, data$x3[i], param, data)
					}
				}
				else {
					if(is.na(data$x3[i])) {
						data$x2[i] * ev_given_u(1, 2, 3, data$x2[i], param, data)
					}
					else {
						data$x2[i] * ev_given_uw(1, 2, 3, data$x2[i], data$x3[i], param, data)
					}
				}
			}
			else {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						data$x1[i] * ev_given_u(2, 1, 3, data$x1[i], param, data)
					}
					else {
						data$x1[i] * ev_given_uw(2, 1, 3, data$x1[i], data$x3[i], param, data)
					}
				}
				else {
					if(is.na(data$x3[i])) {
						data$x1[i] * data$x2[i]
					}
					else {
						data$x1[i] * data$x2[i]
					}
				}
			}
		s[5] <- s[5] +
			if(is.na(data$x1[i])) {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						evw(1, 2, 3, param, data)
					}
					else {
						data$x3[i] * ev_given_u(1, 3, 2, data$x3[i], param, data)
					}
				}
				else {
					if(is.na(data$x3[i])) {
						evw_given_u(1, 2, 3, data$x2[i], param, data)
					}
					else {
						data$x3[i] * ev_given_uw(1, 2, 3, data$x2[i], data$x3[i], param, data)
					}
				}
			}
			else {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						data$x1[i] * ev_given_u(3, 1, 2, data$x1[i], param, data)
					}
					else {
						data$x1[i] * data$x3[i]
					}
				}
				else {
					if(is.na(data$x3[i])) {
						data$x1[i] * ev_given_uw(3, 1, 2, data$x1[i], data$x2[i], param, data)
					}
					else {
						data$x1[i] * data$x3[i]
					}
				}
			}
		s[6] <- s[6] +
			if(is.na(data$x1[i])) {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						evw(2, 1, 3, param, data)
					}
					else {
						data$x3[i] * ev_given_u(2, 3, 1, data$x3[i], param, data)
					}
				}
				else {
					if(is.na(data$x3[i])) {
						data$x2[i] * ev_given_u(3, 2, 1, data$x2[i], param, data)
					}
					else {
						data$x2[i] * data$x3[i]
					}
				}
			}
			else {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						evw_given_u(2, 1, 3, data$x1[i], param, data)
					}
					else {
						data$x3[i] * ev_given_uw(2, 1, 3, data$x1[i], data$x3[i], param, data)
					}
				}
				else {
					if(is.na(data$x3[i])) {
						data$x2[i] * ev_given_uw(3, 1, 2, data$x1[i], data$x2[i], param, data)
					}
					else {
						data$x2[i] * data$x3[i]
					}
				}
			}
		s[7] <- s[7] +
			if(is.na(data$x1[i])) {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						ev(1, 2, 3, param, data)
					}
					else {
						ev_given_u(1, 3, 2, data$x3[i], param, data)
					}
				}
				else {
					if(is.na(data$x3[i])) {
						ev_given_u(1, 2, 3, data$x2[i], param, data)
					}
					else {
						ev_given_uw(1, 2, 3, data$x2[i], data$x3[i], param, data)
					}
				}
			}
			else {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						data$x1[i]
					}
					else {
						data$x1[i]
					}
				}
				else {
					if(is.na(data$x3[i])) {
						data$x1[i]
					}
					else {
						data$x1[i]
					}
				}
			}
		s[8] <- s[8] +
			if(is.na(data$x1[i])) {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						ev(2, 1, 3, param, data)
					}
					else {
						ev_given_u(2, 3, 1, data$x3[i], param, data)
					}
				}
				else {
					if(is.na(data$x3[i])) {
						data$x2[i]
					}
					else {
						data$x2[i]
					}
				}
			}
			else {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						ev_given_u(2, 1, 3, data$x1[i], param, data)
					}
					else {
						ev_given_uw(2, 1, 3, data$x1[i], data$x3[i], param, data)
					}
				}
				else {
					if(is.na(data$x3[i])) {
						data$x2[i]
					}
					else {
						data$x2[i]
					}
				}
			}
		s[9] <- s[9] +
			if(is.na(data$x1[i])) {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						ev(3, 1, 2, param, data)
					}
					else {
						data$x3[i]
					}
				}
				else {
					if(is.na(data$x3[i])) {
						ev_given_u(3, 2, 1, data$x2[i], param, data)
					}
					else {
						data$x3[i]
					}
				}
			}
			else {
				if(is.na(data$x2[i])) {
					if(is.na(data$x3[i])) {
						ev_given_u(3, 1, 2, data$x1[i], param, data)
					}
					else {
						data$x3[i]
					}
				}
				else {
					if(is.na(data$x3[i])) {
						ev_given_uw(3, 1, 2, data$x1[i], data$x2[i], param, data)
					}
					else {
						data$x3[i]
					}
				}
			}
	}
	return(matrix(s))
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
	return(matrix(c(
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
# data addressable as data$x1, data$x2, data$x3
# param will be (mu1, mu2, mu3, s11, s21, s22, s31, s32, s33)
result <- em("../tests/data/missingabridged.csv", "../tests/data/trivariatenormalparam", expect, maxim, 10000, 0.001)
stopifnot(
	result[1] == 1,
	abs(result[4] - (2)) < 1,
	abs(result[5] - (4)) < 1,
	abs(result[6] - (6)) < 1,
	abs(result[7] - (18)) < 1,
	abs(result[8] - (18)) < 1,
	abs(result[9] - (27)) < 2,
	abs(result[10] - (23)) < 1,
	abs(result[11] - (28)) < 1,
	abs(result[12] - (33)) < 1
)
