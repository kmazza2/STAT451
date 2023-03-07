\name{newton}
\alias{newton}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
newton
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
newton(data_path, param_path, max_iter, epsabs)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data_path}{
%%     ~~Describe \code{data_path} here~~
}
  \item{param_path}{
%%     ~~Describe \code{param_path} here~~
}
  \item{max_iter}{
%%     ~~Describe \code{max_iter} here~~
}
  \item{epsabs}{
%%     ~~Describe \code{epsabs} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (data_path, param_path, max_iter, epsabs) 
{
    data <- read.table(data_path, header = TRUE, sep = " ")
    param <- as.matrix(read.table(param_path, header = TRUE, 
        sep = " "))
    converged <- FALSE
    start_time <- proc.time()
    for (iter in seq(max_iter)) {
        deriv1 <- d1(param, data)
        deriv2 <- d2(param, data)
        h <- solve((-1) * deriv2, deriv1)
        next_param <- param + h
        if (norm(next_param - param, type = "F") < epsabs) {
            converged <- TRUE
            break
        }
        param <- next_param
    }
    end_time <- proc.time()
    cat("Converged: ", converged, "\nIterations: ", iter, "\nTime: ", 
        (end_time - start_time)[3], "s\nValue: ", next_param, 
        "\n")
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
