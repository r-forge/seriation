\name{rapriori}
\alias{rapriori}
\title{Call apriori}
\description{
  Mining frequent itemsets, association rules and hyperedges.
}
\usage{
rapriori(data, parameter = NULL, appearance = NULL, control = NULL)
}
\arguments{
  \item{data}{binary matrix, data.frame or \code{arMatrix}}
  \item{parameter}{Object of class \code{APparameter} or named list.}
  \item{appearance}{Object of class \code{ASappearance} or named list.}
  \item{control}{Object of class \code{APcontrol} or named list.}
}
\details{
  Calls the C code \code{apriori} by Christian Borgelt for mining
  frequent itemsets/rules/hyperedgesets. 
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
\examples{
data(census.arMatrix)
rules <- rapriori(census.arMatrix)
}
\keyword{models}

