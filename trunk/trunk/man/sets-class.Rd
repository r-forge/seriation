\name{sets-class}
\docType{class}
\alias{sets-class}
\alias{as.character,sets-method}
\alias{as.data.frame,sets-method}
\alias{show,sets-method}
\alias{summary,sets-method}
\alias{summary.sets-class}
\alias{show,summary.sets-method}
\alias{subset,sets-method}
\alias{[,sets-method}

\title{Class "sets"}
\description{A virtual class extended by \code{itemsets}, \code{rules}
  and \code{hyperedges}.}
\section{Objects from the Class}{A virtual Class: No objects may be created from it.}
\section{Methods}{
  \describe{
    \item{as.character}{\code{signature(x = "sets")}: replace row
      indices by labels}
    \item{as.data.frame}{\code{signature(x = "sets")}:
      transform it into printable form.}
    \item{show}{\code{signature(object = "sets")}}
    \item{summary}{\code{signature(object = "sets")}: give an
      overview over sets.}
    \item{subset}{\code{signature(x = "sets")}: select sets
      fulfilling certain conditions.}
    \item{[}{\code{signature(x = "sets")}}
  }
}
\author{Bettina Gruen}
\seealso{\code{\link{itemsets-class}}, \code{\link{rules-class}}}
\keyword{classes}
