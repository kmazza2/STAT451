\name{newton}
\alias{newton}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
newton
}
\description{
Finds local extremum of function with derivatives d1, d2.
}
\usage{
newton(data_path, param_path, d1, d2, max_iter, epsabs)
}
%- maybe also 'usage' for other objects documented here.
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
  \item{d2}{
function d2(param, data) giving second derivative @ param using data
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
