\name{dissimilarity}
\alias{dist}
\alias{seriation_dist}
\alias{seriation_cor}
\alias{seriation_align}
\title{Dissimilarity Between Seriation Orders}
\description{
Calculates dissimilarities/correlations between seriation orders in a list.
}
\usage{
seriation_dist(x, method = "spearman")
seriation_cor(x, method = "spearman")
seriation_align(x, method = "spearman")
}
\arguments{
  \item{x}{seriation orders as a list with elements of class 
    \code{ser_permutation}.}
  \item{method}{ a character string with the name of the used measure
    (\code{"kendall"}, \code{"spearman"}, \code{"manhattan"}, 
    \code{"euclidean"}).}
}
\details{
For \code{seriation_dist},
the correlation coefficients (Kendall's tau and Spearman's rho) are converted
into a dissimilarity by taking one minus the absolute value. The absolute
value is used since a negative correlation just means that reversing the
order results in a positive correlation of the same magnitude.

For the ranking-based distance measures (Manhattan and Euclidean), 
the direction of the distance between all seriations in forward and
reverse order and use the minimum. Note that Manhattan distance between the 
ranks in a linear order is equivalent to Spearman's footrule 
metric (Diaconis 1988).

\code{seriation_align} normalizes in a list of seriations the direction such 
that ranking-based methods can be used. For the 
correlation coefficients \code{"spearman"} and \code{"kendall"} we 
first find the order which has the largest sum of positive correlations with
all other orders. We use this order as the seed and reverse all orders that 
are negatively correlated. For \code{"manhattan"} and \code{"euclidean"}
we add all reversed orders to the set and then
use a modified version of Prim's
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
\author{Michael Hahsler}
\examples{
## seriate dist of 20 flowers from the iris data set
data("iris")
x <- as.matrix(iris[-5])
x <- x[sample(1:nrow(x), 25),]
rownames(x) <- 1:25
d <- dist(x)

## create a list of different seriations
methods <- c("HC_single", "HC_complete", "OLO", "GW", "R2E", "VAT", 
  "TSP", "Spectral", "SPIN", "MDS", "Identity", "Random")

os <- sapply(methods, function(m) {
  cat("Doing ", m, " ... ")
  tm <- system.time(o <- seriate(d, method = m))
  cat("took ", tm[3],"s.\n")
  o
})

## compare the methods using distances (default distance ignores reversed orders)
ds <- seriation_dist(os)
hmap(ds, margin=c(7,7))

## comapte using actual correlation (reversed orders are neg. correlated!)
cs <- seriation_cor(os)
hmap(cs, margin=c(7,7))
  
## normalize direction of the seriation orders
os2 <- seriation_align(os)
cs2 <- seriation_cor(os2)
hmap(cs2, margin=c(7,7))
 
## plot the actual seriations  
for(i in os2) pimage(d, i, main = get_method(i))
}
\keyword{cluster}
