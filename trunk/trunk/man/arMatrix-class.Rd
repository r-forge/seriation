\name{arMatrix-class}
\docType{class}
\alias{arMatrix-class}
\alias{as.character,arMatrix-method}
\alias{show,arMatrix-method}
\alias{\%in\%,arMatrix-method}
\alias{attributes-class}
\alias{[,arMatrix-method}

\title{Class "arMatrix"}
\description{Extends \code{cscMatrix} by including information on
  factors and levels which are associated with the rows of the sparse matrix.}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("arMatrix",
  ...)}, or from matrices and data frames.
}
\section{Slots}{
  \describe{
    \item{\code{levels}:}{Object of class \code{"list"}}
    \item{\code{attr}:}{Object of class \code{"character"}}
    \item{\code{assign}:}{Object of class \code{"integer"}}
    \item{\code{labels}:}{Object of class \code{"character"}}
    \item{\code{p}:}{Object of class \code{"integer"}}
    \item{\code{i}:}{Object of class \code{"integer"}}
    \item{\code{x}:}{Object of class \code{"numeric"}}
    \item{\code{Dim}:}{Object of class \code{"integer"}}
    \item{\code{factorization}:}{Object of class \code{"list"}}
  }
}
\section{Extends}{
  Class \code{"cscMatrix"}, directly.
  Class \code{"attributes"}, directly.
}
\section{Methods}{
  \describe{
    \item{[}{\code{signature(x = "arMatrix")}}
    \item{as.character}{\code{signature(x = "arMatrix")}: replace row
      numbers by labels}
    \item{as.list}{\code{signature(x = "arMatrix")}: create a list
      element for each column containing the row indices of elements
      unequal to zero}
    \item{\%in\%}{\code{signature(x = "arMatrix")}: determine for each
      column if the elements specified by \code{table} are unequal to
      zero/present in the transaction set}
    \item{show}{\code{signature(object = "arMatrix")}}
  }
}
\author{Bettina Gruen}
\seealso{\code{\link[Matrix]{cscMatrix-class}}}
\keyword{classes}
