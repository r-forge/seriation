\name{Robinson}
\alias{Robinson}
\alias{is.robinson}
\title{Recognize Robinson and Pre-Robinson Matrices}
\description{
Provides functions to recognize (anti) Robinson and pre-Robinson matrices.
A (anti) Robinson matrix has strictly decreasing (increasing) values when
moving away from the main diagonal. A pre-Robinson matrix is a matrix which
can be transformed into a perfect Robinson matrix using simultaneous 
permutations of rows and columns. 
}
\usage{
is.robinson(x, anti = TRUE, pre = FALSE)
}
\arguments{
  \item{x}{a symmetric, positive matrix or a dissimilarity matrix 
  (a \code{dist} object). }
  \item{anti}{logical; check for anti Robinson structure? Note
  that for distances, anti Robinson structure is appropriate. }
  \item{anti}{logical; recognize also pre-Robinson matrices. }
}  
%\details{
%}
\value{
A single logical value.
}
%\seealso{
%}
\examples{
## create a perfect Robinson structure  
d <- dist(1:10)
pimage(d)

is.robinson(d)

## permute the structure to make it not Robinsonian. However,
## it is still pre-Robinson.
d2 <- permute(d, sample(10))
pimage(d2)

is.robinson(d2)
is.robinson(d2, pre = TRUE)
}
%\keyword{manip}
