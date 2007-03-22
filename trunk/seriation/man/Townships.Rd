\name{Townships}
\alias{Townships}
\docType{data}
\title{Bertin's Characteristics and Townships Data Set}
\description{
  This data set was used to illustrate that the conciseness of presentation
    can be improved by reordering the rows and columns.
}
\usage{data("Townships")}
\format{
  A matrix with 16 0-1 variables (columns) indicating the presence
  (\code{1}) or absence (\code{0}) of characteristics of townships
  (rows).
}
\references{
    Bertin, J. (1981): \emph{Graphics and Graphic Information Processing}.
      Berlin, Walter de Gruyter.
}
\examples{
data("Townships")

## original data
pimage(Townships)
criterion(Townships, method = "all")


## reordered data
order <- reorder(Townships, method ="bea")
pimage(Townships, order)
criterion(Townships, order = order, method = "all")

}
\keyword{datasets}
