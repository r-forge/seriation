\name{rapriori}
\alias{rapriori}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Call apriori}
\description{
  Mining association rules
}
\usage{
rapriori(data, parameter = NULL, appearance = NULL, control = NULL)
}
\arguments{
  \item{data}{binary matrix or data.frame}
  \item{parameter}{Object of class \code{APparameter} or names list.}
  \item{appearance}{Object of class \code{ASappearance} or names list.}
  \item{control}{Object of class \code{APcontrol} or names list.}
}
\details{
  
}
\value{
  Returns an object of class \code{arules}.
}
\references{
  Christian Borgelt and Rudolf Kruse. Induction of Association Rules:
  Apriori Implementation. 15th Conference on Computational Statistics
  (Compstat 2002, Berlin, Germany) Physica Verlag, Heidelberg, Germany
  2002

  Christian Borgelt. Efficient Implementations of Apriori and
  Eclat. Workshop of Frequent Item Set Mining Implementations (FIMI 2003,
  Melbourne, FL, USA).
}
\author{Bettina Gruen}
\note{}
\examples{
data(census.assMatrix)
rules <- rapriori(census.assMatrix)
}
\keyword{models}

