\name{itemsets-class}
\docType{class}
\alias{itemsets-class}
\alias{hyperedges-class}
\alias{show,itemsets-method}
\alias{summary,itemsets-method}

\title{Class "itemsets" ~~~ }
\description{  ~~ A concise (1-5 lines) description of what the class is.  ~~}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("itemsets", ...)}.
    ~~ describe objects here ~~ 
}
\section{Slots}{
  \describe{
    \item{\code{rnt}:}{Object of class \code{"integer"} ~~ }
    \item{\code{body}:}{Object of class \code{"bsrMatrix"} ~~ }
    \item{\code{quality}:}{Object of class \code{"data.frame"} ~~ }
    \item{\code{labels}:}{Object of class \code{"character"} ~~ }
  }
}
\section{Extends}{
Class \code{"set"}, directly.
}
\section{Methods}{
  \describe{
    \item{as.character}{\code{signature(x = "itemsets")}: ... }
    \item{extractRules}{\code{signature(object = "itemsets")}: ... }
    \item{show}{\code{signature(object = "itemsets")}: ... }
    \item{subset}{\code{signature(x = "itemsets")}: ... }
    \item{summary}{\code{signature(object = "itemsets")}: ... }
  }
}
\references{ ~put references to the literature/web site here ~ }
\author{Bettina Gruen}
\note{ ~~further notes~~ }
\seealso{\code{\link{sets-class}}}
\keyword{classes}
