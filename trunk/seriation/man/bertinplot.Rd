\name{bertinplot}
\alias{bertinplot}
\title{Plot a Bertin matrix using bars}
\description{
Plot a data matrix of cases and variables as a matrix of bars. High values are
highlighted.  The matrix can be rearranged to make structure in the data
visible (see Falguerolles et al 1997).
}
\usage{
bertinplot(x, highlight = NULL,  options = NULL)   
}
\arguments{
  \item{x}{ a data matrix (columns are variables and rows are cases).}
  \item{highlight}{ a logical matrix of the same dimensions as \code{x} 
      indicating which values to highlight. If \code{NULL} each value
      larger than the mean of all values of a variable are highlighted.}
  \item{options}{a list with options for plotting the matrix. The
      list can contain the following elements:

      \describe{
  \item{\code{barwidth}}{ width of bars (default: 0.8).}
  \item{\code{mar}}{ margins (see par).}
  \item{\code{cex}}{ fontsize multiplier (see par).}
  \item{\code{newpage}}{ a logical indicating  whether to start plot on a new
      page (see \code{grid.newpage} in package \pkg{grid}). }
  \item{\code{pop}}{a logical indicating  whether to  pop the created viewports
      (see package \pkg{grid})?  }
  }
}}
%\details{
%}
%\value{
%}
\references{
de Falguerolles, A., Friedrich, F., Sawitzki, G. (1997):
A Tribute to J. Bertin's Graphical Data Analysis.
In: Proceedings of the SoftStat '97 (Advances in Statistical Software 6),
11--20.
}
\seealso{
   Package \pkg{grid}.
}
\author{Michael Hahsler}
%\examples{
%}
\keyword{hplot}
\keyword{cluster}
