\name{reclat}
\alias{reclat}
\title{Call eclat}
\description{
  Mining frequent itemsets.
}
\usage{
reclat(data, parameter = NULL, control = NULL)
}
\arguments{
  \item{data}{binary matrix, data.frame or \code{assMatrix}}
  \item{parameter}{Object of class \code{ECparameter} or named list.}
  \item{control}{Object of class \code{ECcontrol} or named list.}
}
\details{
  Calls the C code \code{eclat} by Christian Borgelt for mining
  frequent itemsets. 
}
\value{
  Returns an object of class \code{arules}.
}
\references{
  Christian Borgelt. Efficient Implementations of Apriori and
  Eclat. Workshop of Frequent Item Set Mining Implementations (FIMI 2003,
  Melbourne, FL, USA).
}
\author{Bettina Gruen}
\seealso{\code{\link{rapriori}}}
\examples{
data(census.assMatrix)
sets <- reclat(census.assMatrix)
}
\keyword{models}

