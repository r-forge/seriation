\name{Psych24}
\alias{Psych24}
\docType{data}
\title{Psych24 -- 24 psychological tests}
\description{
A data set collected by Holzinger and Swineford (1939) which consists of the
results of 24 psychological tests given to 145 seventh and eighth grade
students in a Chicago suburb. This data set contains the correlation matrix
for the 24 test results.

The data set was also used as an example for vizualization of cluster analysis
by Ling (1973).

}
\usage{data("Psych24")}
\format{
 A 24 x 24 correlation matrix.  
}
%\details{
%}
\references{
Holzinger, K. L., Swineford, F. (1939): 
A study in factor analysis: The stability of a bi-factor solution.
\emph{Supplementary Educational Monograph,} No. \bold{48}. 
Chicago: University of Chicago Press.

Ling, R. L. (1973): A computer generated aid for cluster analysis. 
\emph{Communications of the ACM}, 
\bold{16}(6), pp. 355--361.
}
\examples{
data("Psych24")

## create a dist object and also get rid of the one negative entry in the
## correlation matrix
d <- as.dist(1-abs(Psych24))

pimage(d)

## do hclust as in Ling (1973)
hc <- hclust(d, method = "complete")
plot(hc)

pimage(arrange(d, hc$order))

## use reordering
order <- reorder(d, method = "tsp")
#order <- reorder(d, method = "tsp", options = list(method = "concorde"))
pimage(arrange(d, order))
}
\keyword{datasets}
