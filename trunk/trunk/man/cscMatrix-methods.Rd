\name{cscMatrix-methods}
\docType{methods}
\alias{[,cscMatrix-method}
\alias{as.list,cscMatrix-method}
\title{Methods for class "cscMatrix" compressed, sparse, column Matrix}
\description{
  Class \code{cscMatrix} is defined in package \code{Matrix} together
  with some methods. Additional methods are implemented which are used
  for the directly extending class \code{arMatrix}.
}
\section{Methods}{
  \describe{
    \item{as.list}{\code{signature(x = "cscMatrix")}: converts a
      \code{cscMatrix} into a list with the number of element equal to
      the number of columns of the \code{cscMatrix} and where each list
      element contains the indices of the rows uneqal to zero for the
      respective columns.} 
    \item{[}{\code{signature(x = "cscMatrix")}:
      usual subsetting for matrices.}
  }
}
\seealso{\code{\link{arMatrix-class}}}
\keyword{methods}

