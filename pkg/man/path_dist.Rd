\name{iVAT}
\alias{path_dist}
\alias{iVAT}
\alias{create_lines_data}
\title{Calculate Path Dist Used in iVAT}
\description{
Implements improved Visual Analysis
for Cluster Tendency Assessment (iVAT) by Wang et al (2010).
}
\usage{
path_dist(x)
create_lines_data(n=250)
}
\arguments{
  \item{x}{a \code{dist} object.}
  \item{n}{number of data points to create.}
}
\details{
Redefines the distance between two objects as the minimum over
the largest distances in all possible paths between the objects.

\code{creat_lines_data} creates the lines data set used in 
Havens and Bezdeck (2011).
}
%\author{Michael Hahsler}
\seealso{
\code{\link{seriate}}
}
\references{
Wang L., U.T.V. Nguyen, J.C. Bezdek,
C.A. Leckie and K. Ramamohanarao (2010):
iVAT and aVAT: Enhanced Visual Analysis
for Cluster Tendency Assessment,
\emph{Proceedings of the PAKDD 2010, Part I, LNAI 6118,} 16--27.
  
Havens, T.C. and Bezdek, J.C. (2011):
An Efficient Formulation of the Improved Visual Assessment of Cluster Tendency (iVAT) Algorithm, \emph{IEEE Transactions on Knowledge and Data Engineering,}   \bold{24}(5), 813--822. 
}
\examples{
## lines data set from Havens and Bezdek (2011) 
x <- create_lines_data(250)
plot(x, xlim=c(-5,5), ylim=c(-4,4), cex=.2)
  
d <- dist(x)

## create VAT
pimage(d, seriate(d, "VAT"))  

## create iVAT which recovers the three lines
d_path <- path_dist(d)
pimage(d_path, seriate(d_path, "VAT"))  
}
\keyword{cluster}
\keyword{manip}