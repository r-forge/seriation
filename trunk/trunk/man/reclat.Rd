\name{reclat}
\alias{reclat}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Call eclat}
\description{
  Mining frequent item sets
}
\usage{
reclat(data, parameter = NULL, control = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{ ~~Describe \code{data} here~~ }
  \item{parameter}{ ~~Describe \code{parameter} here~~ }
  \item{control}{ ~~Describe \code{control} here~~ }
}
\details{
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

