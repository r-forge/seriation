\name{dissimilarity}
\alias{dist}
\alias{seriation_dist}
\alias{seriation_align}
\title{Dissimilarity Between Seriation Orders}
\description{
Calculates the dissimilarity between a set of seriation orders.
}
\usage{
seriation_dist(x, method = "kendall")
seriation_align(x, method = "manhattan")
}
\arguments{
  \item{x}{seriation orders as a list with elements of class 
    \code{ser_permutation}.}
  \item{method}{ a character string with the name of the used measure
    (\code{"kendall"}, \code{"spearman"}, \code{"manhattan"}, 
    \code{"euclidean"}). Alignment only supports \code{"manhattan"} and 
    \code{"euclidean"}.}
}
\details{
The correlation coefficients (Kendall's tau and Spearman's rho) are converted
into a dissimilarity by taking one minus the absolute value. The absolute
value is used since a negative correlation just means that reversing the
order results in a positive correlation of the same magnitude.

For the ranking-based distance measures (Manhattan and Euclidean), 
the direction of the distance between all seriations in forward and
reverse order and use the minimum. Note that Manhattan distance between the 
ranks in a linear order is equivalent to Spearman's footrule 
metric (Diaconis 1988).

\code{seriation_align} normalizes in a list of seriations the direction such 
that ranking-based methods can be used. We use a modified version of Prim's
algorithm for finding a minimum spanning tree (MST) to choose if the original seriation order or its reverse should be used. We use the orders first added to 
the MST. Every time an order is added, its reverse is removed from the possible 
orders.
}
\value{
\code{seriation_dist} returns an object of class \code{dist}.
\code{seriation_align} returns a new list with elements of class 
    \code{ser_permutation}.
}
\references{ 
P. Diaconis (1988): Group Representations in Probability and Statistics. Institute of Mathematical Statistics, Hayward, CA.
}
\seealso{
\code{\link{ser_permutation_vector}}
}
\examples{
## seriate dist of 20 flowers from the iris data set
data("iris")
x <- as.matrix(iris[-5])
x <- x[sample(1:nrow(x), 25),]
d <- dist(x)

## create a list of different seriations
methods <- c("HC_single", "HC_complete", "OLO", "GW", "R2E", "VAT", 
  "TSP", "Spectral", "MDS", "Identity", "Random")

os <- sapply(methods, function(m) {
  cat("Doing ", m, " ... ")
  tm <- system.time(o <- seriate(d, method = m))
  cat("took ", tm[3],"s.\n")
  o
})

## compare the methods
ds1 <- seriation_dist(os, method="kendall")
plot(hclust(ds1))  

ds2 <- seriation_dist(os, method="manhattan")
plot(hclust(ds2))  

## normalize direction so all seriations are visualized in the 
## same general order
os2 <- seriation_align(os)
for(i in os2) pimage(d, i, main = get_method(i))
}
\keyword{cluster}
