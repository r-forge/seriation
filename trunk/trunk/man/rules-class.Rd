\name{rules-class}
\docType{class}
\alias{rules-class}
\alias{summary,rules-method}
\alias{subset,rules-method}
\alias{summary.rules-class}

\title{Class "rules"}
\description{Data structure for rules.}
\section{Objects from the Class}{
  Objects are generally returned by \code{rapriori}.
}
\section{Slots}{
  \describe{
    \item{\code{rnt}:}{\code{"integer"}; number of rules}
    \item{\code{head}:}{\code{"cscMatrix"}; items contained in the head
      of the ruels.}
    \item{\code{body}:}{\code{"cscMatrix"}; items contained in the body
      of the rules}
    \item{\code{quality}:}{\code{"data.frame"}; quality measures as
      e.g. support, confidence, \dots}
    \item{\code{levels}:}{\code{"list"}}
    \item{\code{attr}:}{\code{"character"}}
    \item{\code{assign}:}{\code{"integer"}}
    \item{\code{labels}:}{\code{"character"}}
  }
}
\section{Extends}{
  Class \code{"sets"}, directly.
  Class \code{"hyperedges"}, directly.
}
\section{Methods}{
  \describe{
    \item{subset}{\code{signature(object = "rules")}: select rules
      fulfilling certain conditions.}
  }
}
\author{Bettina Gruen}
\seealso{\code{\link{sets-class}}}
\keyword{classes}
