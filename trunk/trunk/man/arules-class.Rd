\name{arules-class}
\docType{class}
\alias{arules-class}
\alias{show,arules-method}
\alias{summary,arules-method}
\alias{as.data.frame,arules-method}
  
\title{Class "arules"}
\description{Contains the call, the parameter specification which
  itemsets/rules/hyperedges are mined and how and the resulting sets.}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("arules", ...)}.

Returned by \code{rapriori} and \code{reclat}.
}
\section{Slots}{
  \describe{
    \item{\code{call}:}{Object of class \code{"call"}}
    \item{\code{parameter}:}{Object of class \code{"ASparameter"}}
    \item{\code{control}:}{Object of class \code{"AScontrol"}}
    \item{\code{sets}:}{Object of class \code{"sets"}}
  }
}
\section{Methods}{
  \describe{
    \item{show}{\code{signature(object = "arules")}}
    \item{summary}{\code{signature(object = "arules")}: applies this
      function to slots \code{sets}} 
    \item{as.data.frame}{\code{signature(object = "arules")}: applies
      this function to slots \code{sets}}
  }
}
\author{Bettina Gruen}
\seealso{\code{\link{rapriori}}, \code{\link{reclat}}, \code{\link{sets-class}}}
\keyword{classes}
