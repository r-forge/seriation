\name{ASparameter-class}
\docType{class}
\alias{APparameter-class}
\alias{ASparameter-class}
\alias{ECparameter-class}
\alias{.parameter-class}
\alias{show,.parameter-method}

\title{Classes "ASparameter", "APparameter", "ECparameter" - specifying
  the parameter argument of "rapriori" and "reclat"}
\description{
  \code{APparameter} and \code{ECparameter} directly extend
  \code{ASparameter}. They have additional slots for parameters only
  suitable for \code{rapriori} and \code{reclat}.
}
\section{Objects from the Class}{
  Objects can be created by calls of the form \code{new("APparameter",
    ...)}.

  By specifying a named list (names equal to slots) as \code{parameter}
  argument for \code{rapriori} and \code{reclat} these objects will be
  created and the default values replaced by the given values.

}
\section{Slots}{
  \describe{
    \item{\code{support}:}{\code{"numeric"}; minimal support of a item
      set (default: 0.1)}
    \item{\code{minlen}:}{\code{"integer"}; minimal number of items per
      item set (default: 1)}
    \item{\code{maxlen}:}{\code{"integer"}; maximal number of items per
      item set (default: 5)}
    \item{\code{target}:}{\code{"character"}; indicating target type by
      one of "frequent item sets", "maximally frequent item sets",
      "closed item sets" and in addition "rules", "hyperedgesets" for \code{rapriori}}
    \item{\code{ext}:}{\code{"logical"}; give extended information on
      quality measures back}
  }
  Additional slots of \code{APparameter}:
  \describe{
    \item{\code{confidence}:}{\code{"numeric"}; minimal confidence of a
      rule/hyperedge (default: 0.8)}
    \item{\code{minval}:}{\code{"numeric"}; minimal value of additional
      evaluation measure (default: 0.1)}
    \item{\code{smax}:}{\code{"numeric"}; maximal support of a
      set/rule/hyperedge (default: 1)}
    \item{\code{arem}:}{\code{"character"}; additional rule evaluation
      measure (default: none) given by one of
      \describe{
	\item{none:}{no additional evaluation measure}
	\item{diff:}{absolute confidence difference}
	\item{quot:}{difference of conf. quotient to 1}
	\item{aimp:}{abs. diff. of improvement to 1}
	\item{info:}{information difference to prior}
	\item{chi2:}{normalized \eqn{\chi^2} measure}
      }
    }
    \item{\code{aval}:}{\code{"logical"}; extended support output (print
      both rule support types)}
    \item{\code{originalSupport}:}{\code{"logical"}; use original
      definition of the support of a rule (body and head)}
  }
  Additional slots of \code{ECparameter}:
  \describe{
    \item{\code{trans}:}{\code{"logical"}; list of supporting
      transactions (record numbers)}
  }
}
\references{
  Christian Borgelt. Apriori --- Finding Association Rules/Hyperedges
  with the Apriori Algorithm. Manual. 2004 
  }
\author{Bettina Gruen}
\seealso{\code{\link{rapriori}}, \code{\link{reclat}}} 
\keyword{classes}
