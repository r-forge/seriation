\name{AScontrol-class}
\docType{class}
\alias{AScontrol-class}
\alias{APcontrol-class}
\alias{ECcontrol-class}

\title{Classes "AScontrol", "APcontrol", "ECcontrol" -  specifying the control argument of
  "rapriori" and "reclat"}
\description{
  \code{APcontrol} and \code{ECcontrol} directly extend
  \code{AScontrol}. They have additional slots for parameters only
  suitable for \code{rapriori} and \code{reclat}.
}
\section{Objects from the Class}{
  Objects can be created by calls of the form \code{new("AScontrol",
    ...)}.

  By specifying a named list (names equal to slots) as \code{control}
  argument for \code{rapriori} and \code{reclat} these objects will be
  created and the default values replaced by the given values.
}
\section{Slots}{
  \describe{
    \item{\code{sort}:}{\code{"integer"}; sort items with respect to
      their frequency:
      \describe{
	\item{ 1:}{ascending}
	\item{-1:}{descending}
	\item{ 0:}{do not sort}
        \item{ 2:}{ascending}
	\item{-2:}{descending w.r.t. transaction size sum}
      }
    }
    \item{\code{verbose}:}{\code{"logical"}; report progress}
  }
  Additional slots of \code{APcontrol}:
  \describe{
    \item{\code{filter}:}{\code{"numeric"}; filter unused items from
      transactions (default: 0.1)
      \describe{
	\item{\eqn{=0}:}{do not filter items w.r.t. usage in sets}
	\item{\eqn{<0}:}{fraction of removed items for filtering}
	\item{\eqn{>0}:}{take execution times ratio into account}
      }
    }
    \item{\code{tree}:}{\code{"logical"}; organize transactions as a prefix tree}
    \item{\code{heap}:}{\code{"logical"}; use heapsort or quicksort to
      sort the transactions (default: heapsort)}
    \item{\code{memopt}:}{\code{"logical"}; maximize speed or minimize
      memory usage (default: maximize speed)}
    \item{\code{load}:}{\code{"logical"}; do not load transactions into memory}
  }
  Additional slots of \code{ECcontrol}:
  \describe{
    \item{\code{sparse}:}{\code{"numeric"};  threshold for sparse representation (default: 7)}
  } 
}
\references{
  Christian Borgelt. Apriori --- Finding Association Rules/Hyperedges
  with the Apriori Algorithm. Manual. 2004 
  }
\author{Bettina Gruen}
\seealso{\code{\link{rapriori}}, \code{\link{reclat}}}  
\keyword{classes}
