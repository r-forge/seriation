\name{ASappearance-class}
\docType{class}
\alias{ASappearance-class}

\title{Class "ASappearance" - specifying the appearance argument of "rapriori"}
\description{Specifies the restrictions on the frequent
  itemsets/association rules/hyperedges mined by \code{rapriori}.}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("APappearance", ...)}.

In general these objects will be created within \code{rapriori} by
specifying a named list as \code{appearance} argument. Lexical scopying
is used within \code{rapriori} to match the labels, levels or factors
specified to appear in the body, head, both or not with the columns of
the incidence matrix. The named list can have the following entries
\describe{
  \item[default:] one of body, head, both, none (or other names specified
  in the ``apriori'' manual).
  \item[body, head, both, none:] character vector giving the names of
  the levels or factors to be included/excluded or integer vector giving
  the respective columns
}
}
\section{Slots}{
  \describe{
    \item{\code{set}:}{\code{"integer"} indicating how many items are
      specified for each of body, head, both and none}
    \item{\code{items}:}{\code{"integer"} indicating the column number}
    \item{\code{labels}:}{\code{"character"} vector of column names/labels}
    \item{\code{default}:}{\code{"character"} indicating the default value}
  }
}
\references{
  Christian Borgelt. Apriori --- Finding Association Rules/Hyperedges
  with the Apriori Algorithm. Manual. 2004 
  }
\author{Bettina Gruen}
\seealso{\code{\link{rapriori}}}
\keyword{classes}
