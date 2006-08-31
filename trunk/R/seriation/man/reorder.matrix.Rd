\name{reorder.matrix}
\alias{reorder.matrix}
\title{Reorder a matrix}
\description{
Tries to find an order for the objects (rows or columns) by moving large values
closer together. Using a image plot of the reordered matrix can show a
structure in the data which was not visible in the original matrix.
}
\usage{
\method{reorder}{matrix}(x, method = NULL, row = TRUE, options = NULL, \ldots)
}
\arguments{
  \item{x}{ a matrix.}
  \item{method}{ a character string with the name of the seriation method
    (default: \code{"murtagh"}) or a function call (suitable functions need to
    accept the arguments \code{(x, method, options)} and return an order).}
  \item{row}{ if \code{row=TRUE} the order for rows is calculated, 
    otherwise for columns. }
  \item{options}{ a list of options passen on to the reorder algorithms.}
  \item{\ldots}{ further arguments (unused).}
    }
\details{
    Currently the following methods are implemented:
\describe{
    \item{\code{"bea"}}{Bond Endergy Algorithm (BEA; McCormick 1972).
     
The algorithm tries to maximize the summed bond energy (see bond energy
     in \code{criterion}) of a nonnegative matrix. 
     
    A row is arbitrarily placed; then rows are positioned one by one. When this
    is completed, the columns are treated similarly. The overall procedure
    amounts to two approximate traveling salesman problems (TSP), one on the
    rows and one on the columns. The so-called `best insertion strategy' is
    used: Rows (or columns) are inserted into the current permuted list of rows
    (or columns). Note that several runs of the algorithm on the
    previously reordered matrix might improve the energy.  

    For symmetric matrices (one-mode data; e.g., dissimilarity matrices), only
one TSP has to be solved. The two TSPs (for rows and columns) for general
matrices (two-mode data) are separable and here only one problem is solved
(depending on the value of \code{row}). Therefore, to apply BEA for two-mode
data, \code{reorder} has to be used twice. 
      
Note that Arabie and Hubert (1990)
recommend that it be used with ratio scale data and they question its use 
with non-binary data if the objective is to find a seriation or 
one-dimensional ordering of rows and columns. 
      }

\item{\code{"murtagh"}}{Algorithm B (Murtagh 1985). 
      
        A simple heuristic which also tries to maximize the summed bond energy
      (see BEA) of a nonnegative matrix.
      It uses the cross-product of the matrix (an unnormalized form
      of the Pearson correlation) and \code{hclust_greedy} to obtain the
      ordering. For \code{hclust_greedy} in each step a single cluster is
      constructed by merging the leaf closest to one of the two endpoints of
      the cluster. The algorithm starts with a random leaf and uses
      tie-breaking.
      
      Note that the ordering can change from run to run since ties are broken
      randomly.}

\item{\code{"fpc"}}{First principal component. 
      
        Uses the projection of the data on its
      first principal component to determine the order. 
      
      Note that for a distance matrix calculated from \code{x} with 
      Euclidean distance, this methods minimizes the least square criterion.}  
}}
\value{
Returns an integer vector containing the ordering of the rows or columns. 
}
\references{ 
P. Arabie and L.J. Hubert (1990): The bond energy algorithm revisited, 
\emph{IEEE Transactions on Systems, Man, and Cybernetics,}
\bold{20}(1), pp. 268--274.

W.T. McCormick, P.J. Schweitzer and T.W. White (1972): Problem decomposition
and data reorganization by a clustering technique, 
\emph{Operations Research,} 
\bold{20}(5), pp. 993--1009.

F. Murtagh (1985): Multidimensional Cluster Algorithms. 
\emph{Lectures in Computational Statistics}, Chapter 1, 
Physica Verlag, pp. 9--31.
}
\seealso{
\code{\link{hclust_greedy}},
\code{\link{criterion}}.
}
%\author{Michael Hahsler}
\examples{
data("iris")
x <- as.matrix(iris[,1:4])


## try some methods
def.par <- par(no.readonly = TRUE)
layout(rbind(1:2, 3:4, 5:6), respect=TRUE)

pimage(x, main = "original data")
criterion(x)

r <- reorder(x, row = TRUE)
c <- reorder(x, row = FALSE)
pimage(x[r,c], main = "Murtagh")
criterion(x, list(row = r, col = c))


r <- reorder(x, method="bea", row = TRUE)
c <- reorder(x, method="bea", row = FALSE)
pimage(x[r,c], main = "BEA")
criterion(x, list(row = r, col = c))

r <- reorder(x, method="fpc", row = TRUE)
c <- reorder(x, method="fpc", row = FALSE)
pimage(x[r,c], main = "first principal component")
criterion(x, list(row = r, col = c))

r <- reorder(dist(x), method = "tsp")
c <- reorder(dist(t(x)), method = "tsp")
pimage(x[r,c], main = "2 TSPs")
criterion(x, list(row = r, col = c))

par(def.par)
}
\keyword{optimize}
\keyword{cluster}
