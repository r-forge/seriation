\name{itemset-class}
\docType{class}
\alias{itemset-class}
\alias{hyperedgeset-class}
\alias{show,itemset-method}
\alias{summary,itemset-method}

\title{Class "itemset" ~~~ }
\description{  ~~ A concise (1-5 lines) description of what the class is.  ~~}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("itemset", ...)}.
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
    \item{as.character}{\code{signature(x = "itemset")}: ... }
    \item{extractRules}{\code{signature(object = "itemset")}: ... }
    \item{show}{\code{signature(object = "itemset")}: ... }
    \item{subset}{\code{signature(x = "itemset")}: ... }
    \item{summary}{\code{signature(object = "itemset")}: ... }
  }
}
\references{ ~put references to the literature/web site here ~ }
\author{Bettina Gruen}
\note{ ~~further notes~~ }
\seealso{\code{\link{set-class}}}
\keyword{classes}
