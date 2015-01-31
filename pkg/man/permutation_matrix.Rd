\name{permutation_matrix}
\alias{permutation_matrix2vector}
\alias{permutation_vector2matrix}
\title{Conversion between Permutation Vector and Matrix}
\description{
Converts between permutation vectors and matrices.
}
\usage{
permutation_matrix2vector(x)
permutation_vector2matrix(x)
}
\arguments{
  \item{x}{A permutation vector (any object that can be converted into a 
    permutation vector, e.g., a integer vector or a \code{hclust} object) or a 
    matrix representing a permutation. Arguments are checked.} 
}
%\details{
%}
%\author{Michael Hahsler}
\seealso{
\code{\link{ser_permutation}},
\code{\link{permute}}
}
\examples{
## create a random permutation vector
pv <- sample(1:5)
pv
  
## convert into a permutation matrix
pm <- permutation_vector2matrix(pv)
pm
  
## convert back  
permutation_matrix2vector(pm)
}
\keyword{manip}