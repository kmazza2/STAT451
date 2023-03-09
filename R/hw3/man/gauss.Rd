\name{gauss}
\alias{gauss}
\title{
gauss
}
\description{
Finds MLE for distribution with likelihood derivative d1, pointwise residual point_res.
}
\usage{
gauss(data_path, param_path, d1, point_res, max_iter, epsabs)
}
\arguments{
  \item{data_path}{
path to data (will be provided to d1, d2); MUST contain a header
}
  \item{param_path}{
path to initial guess; MUST contain a header
}
  \item{d1}{
function d1(param, data) giving first derivative @ param using data
}
  \item{point_res}{
function point_res(param, data) giving pointwise residual
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
