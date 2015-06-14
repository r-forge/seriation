\name{dissimilarity}
\alias{dist}
\alias{seriation_dist}
\alias{seriation_cor}
\alias{seriation_align}
\title{Dissimilarities and Correlations Between Seriation Orders}
\description{
Calculates dissimilarities/correlations between seriation orders in a list.
}
\usage{
seriation_dist(x, method = "spearman", align = TRUE)
seriation_align(x, method = "spearman")
seriation_cor(x, method = "spearman")
}
\arguments{
  \item{x}{seriation orders as a list with elements of class 
    \code{ser_permutation_vector}.}
  \item{method}{ a character string with the name of the used measure. Available
    measures are:
    \code{"kendall"}, \code{"spearman"}, \code{"manhattan"}, 
    \code{"euclidean"}, \code{"hamming"}, and \code{"ppc"} (positional proximity coefficient). For correlation 
    only \code{"kendall"} and \code{"spearman"} are allowed.}
  \item{align}{a logical indicating if the orders should be pairwise aligned 
    (i.e., also check reversed order) for calculating the distances.}
}
\details{
For \code{seriation_dist},
the correlation coefficients (Kendall's tau and Spearman's rho) are converted
into a dissimilarity by taking one minus the absolute value.
For these and the ranking-based distance measures 
(Manhattan, Euclidean and Hamming), 
the direction of the distance between all seriations in forward and
reverse order are calculated and the pairwise minimum is used 
for \code{align=TRUE}. Note that Manhattan distance between the 
ranks in a linear order is equivalent to Spearman's footrule 
metric (Diaconis 1988).

The positional proximity coefficient (ppc) is a precedence invariant measure based on
the squared positional distances in two permutations (see Goulermas et al 2015).
The similarity measure is converted into a dissimilarity via \eqn{1-ppc}
\code{align} is ignored.

\code{seriation_align} normalizes the direction in a list of seriations such 
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

J.Y. Goulermas, A. Kostopoulos, and T. Mu (2015): A New Measure for Analyzing and Fusing Sequences of Objects. IEEE Transactions on Pattern Analysis and Machine Intelligence. Forthcomming.  
}
\seealso{
\code{\link{ser_permutation_vector}}
}
\author{Michael Hahsler}
\examples{
set.seed(1234)
## seriate dist of 50 flowers from the iris data set
data("iris")
x <- as.matrix(iris[-5])
x <- x[sample(1:nrow(x), 50),]
rownames(x) <- 1:50
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

## compare the methods using distances (default is based on 
## Spearman's rank correlation coefficient)
ds <- seriation_dist(os)
hmap(ds, margin=c(7,7))

## compare using actual correlation (reversed orders are neg. correlated!)
cs <- seriation_cor(os)
hmap(cs, margin=c(7,7))

## normalize direction of the seriation orders. 
## Now all but random and identity are highly pos. correlated
os2 <- seriation_align(os)
cs2 <- seriation_cor(os2)
hmap(cs2, margin=c(7,7))
  
## use Manhattan distance of the ranks (i.e., Spearman's foot rule)
## first without and then with pairwise alignment
ds <- seriation_dist(os, method="manhattan", align=FALSE)
plot(hclust(ds))

ds <- seriation_dist(os, method="manhattan", align=TRUE)
plot(hclust(ds))
}
\keyword{cluster}
