\name{itemsets-class}
\docType{class}
\alias{itemsets-class}
\alias{hyperedges-class}
\alias{show,itemsets-method}
\alias{summary,itemsets-method}

\title{Classes "itemsets" and "hyperedges"}
\description{Data structure for frequent itemsets and hyperedges.}
\section{Objects from the Class}{
Objects are generally returned by \code{rapriori} and \code{reclat}. 
}
\section{Slots}{
  \describe{
    \item{\code{rnt}:}{\code{"integer"}; number of itemsets}
    \item{\code{body}:}{\code{"cscMatrix"}; items contained in the
      itemsets}
    \item{\code{quality}:}{\code{"data.frame"}; quality measures as
      e.g. support, \dots}
    \item{\code{levels}:}{\code{"list"}}
    \item{\code{attr}:}{\code{"character"}}
    \item{\code{assign}:}{\code{"integer"}}
    \item{\code{labels}:}{\code{"character"}}
  }
  Additonal slot for \code{itemsets}:
  \describe{
    \item{\code{trans}:}{\code{"cscMatrix"}; transactions supporting the
      frequent itemsets}
  }
}
\section{Extends}{
Class \code{"sets"}, directly.
}
\author{Bettina Gruen}
\seealso{\code{\link{sets-class}}}
\keyword{classes}
