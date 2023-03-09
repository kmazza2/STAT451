\name{em}
\alias{em}
\title{
em
}
\description{
Implements EM algorithm
}
\usage{
em(data_path, param_path, expect, maxim, max_iter, epsabs)
}
\arguments{
  \item{data_path}{
path to data (will be provided to d1, d2); MUST contain a header
}
  \item{param_path}{
path to initial guess; MUST contain a header
}
  \item{expect}{
function expect(param, data) giving expectation of sufficient statistic given observed data, using param as parameter
}
  \item{maxim}{
function maxim(param, data, expectation) giving parameter value such that unconditional expectation of complete data is equal to expectation
}
  \item{max_iter}{
maximum iterations
}
  \item{epsabs}{
report algorithm converged if distance between successive param values < epsabs
}
}
\value{
  \item{converged }{0 if failed to converge, 1 if converged}
  \item{iter }{number of iterations before convergence}
  \item{time }{CPU time algorithm took to run}
  \item{param }{final value of parameter}
}
