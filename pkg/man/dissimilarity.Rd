\name{dissimilarity}
\alias{dist}
\alias{seriation_dist}
\title{Dissimilarity between seriation orders}
\description{
Calculates the dissimilarity between a set of seriation orders.
}
\usage{
seriation_dist(x, method = "kendall")
}
\arguments{
  \item{x}{seriation orders as a list of class \code{ser_permutation}.}
  \item{method}{ a character string with the name of the used measure
    (\code{"kendall"}, \code{"spearman"}, \code{"manhattan"}, 
    \code{"euclidean"}).}
}
\details{
The correlation coefficients (Kendall's tau and Spearman's phi) are converted
into a dissimilarity by taking one minus the absolute value. The absolute
value is used since a negative correlation just means that reversing the
order results in a positive correlation of the same magnitude.

The distance measures (Manhattan and Euclidean) are calculated between the 
ranks of all orders in both directions and the lowest distance is always 
returned.
}
\value{
Returns an object of class \code{dist}.
}
%\references{ 
%}
\seealso{
\code{\link{ser_permutation_vector}}
}
\examples{
##seriate dist
data("iris")
x <- as.matrix(iris[-5])
x <- x[sample(1:nrow(x)),]
d <- dist(x)

## create a list of differnt seriations
methods <- c("HC_single", "HC_complete", "OLO", "GW", "R2E", "VAT", 
  "TSP", "Spectral", "MDS")

  os <- sapply(methods, function(m) {
  cat("Doing ", m, " ... ")
  tm <- system.time(o <- seriate(d, method = m))
  cat("took ", tm[3],"s.\n")
  o
  })

## compare the methods
ds <- seriation_dist(os, method="kendall")
plot(hclust(ds))  
}
\keyword{cluster}
