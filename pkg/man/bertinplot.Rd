\name{bertinplot}
\alias{bertinplot}
\alias{panel.bars}
\alias{panel.circles}
\alias{panel.squares}
\alias{panel.lines}
\title{Plot a Bertin matrix}
\description{
Plot a data matrix of cases and variables. Each value is represented by a
symbol. Large values are highlighted. The matrix can be rearranged to make
structure in the data visible (see Falguerolles et al 1997).
}
\usage{
bertinplot(x, order = NULL, highlight = TRUE,  options = NULL)   
}
\arguments{
  \item{x}{ a data matrix. Note that following Bertin, 
      columns are variables and rows are cases. This behavior can be 
      reversed using \code{reverse = TRUE} in \code{options}.}
  \item{order}{an object of class \code{ser_permutation} to rearrange \code{x} before
      plotting.  If \code{NULL}, no rearrangement is performed.}
  \item{highlight}{ a logical scalar indicating whether to use highlighting.
      If \code{TRUE}, all variables with values greater than the variable-wise
      mean are  highlighted. To control highlighting, also a 
      logical matrix with the same dimensions as \code{x} can be supplied.}
  \item{options}{a list with options for plotting. The
      list can contain the following elements:

      \describe{
  \item{\code{panel.function}}{ a function to produce the symbols. Currently
      available functions are \code{panel.bars} (default),
      \code{panel.circles},
      \code{panel.squares} and
      \code{panel.lines}.}
  \item{\code{reverse}}{ logical indicating whether to swap cases and variables 
      in the plot. The default (\code{FALSE}) 
      is to plot cases as columns and variables as rows.}
  \item{\code{xlab, ylab}}{ labels (default: use labels from \code{x}).}
  \item{\code{spacing}}{ relative space between symbols (default: 0.2).}
  \item{\code{frame}}{ plot a grid to separate symbols (default: code{FALSE}).}
  \item{\code{mar}}{ margins (see \code{par}).}
  \item{\code{gp_labels}}{ gpar object for labels (see \code{gpar}).}
  \item{\code{gp_panels}}{ gpar object for panels (see \code{gpar}).}
  \item{\code{newpage}}{ a logical indicating  whether to start the plot 
      on a new page (see \code{grid.newpage}). }
  \item{\code{pop}}{a logical indicating whether to pop the created viewports
      (see \code{pop.viewport})?  }
  }
}}
\details{
The plot is organized as a matrix of symbols. The symbols are drawn
by a panel function, where all symbols of a row are drawn 
by one call of the function (using vectorization). The interface for the
panel function is \code{panel.myfunction(value, spacing, hl)}.
\code{value} is the vector of values for a row scaled between 0 and 1, 
\code{spacing} contains the relative space between symbols and
\code{hl} is a logical vector indicating which symbol should be highlighted.
}
%\value{
%}
\references{
de Falguerolles, A., Friedrich, F., Sawitzki, G. (1997):
A Tribute to J. Bertin's Graphical Data Analysis.
In: Proceedings of the SoftStat '97 (Advances in Statistical Software 6),
11--20.
}
\seealso{
    \code{\link{ser_permutation}},
    \code{\link{seriate}},
    Package \pkg{grid}.
}
%\author{Michael Hahsler}
\examples{
data("Irish")
scale_by_rank <- function(x) apply(x, 2, rank)
x <- scale_by_rank(Irish[,-6])

## use the the sum of absolute rank differences
order <- c(
  seriate(dist(x, "minkowski", p = 1)),
  seriate(dist(t(x), "minkowski", p = 1))
)

## plot
bertinplot(x, order)

## alternative display
bertinplot(x, order, 
    options = list(panel = panel.circles, spacing = -0.4))
}
\keyword{hplot}
\keyword{cluster}
