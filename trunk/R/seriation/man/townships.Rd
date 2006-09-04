\name{townships}
\alias{townships}
\docType{data}
\title{Bertin's Characteristics and Townships Data Set}
\description{
  This data set was used to illustrate that the conciseness of presentation
    can be improved by reordering the rows and columns.
}
\usage{data(townships)}
\format{
  The format is:
 int [1:16, 1:9] 0 0 0 0 0 0 0 1 0 0 ...
 - attr(*, "dimnames")=List of 2
  ..$ : chr [1:16] "A" "B" "C" "D" ...
  ..$ : chr [1:9] "High.School" "Agricultural.Coop." "Railway.Station" "One.Room.School" ...
}
\details{
    \code{townships} is a matrix with 16 0-1 variables (columns)
      indicating the presence (\code{1}) or absence (\code{0})
        of characteristics of townships (rows).
}
\references{
    Bertin, J. (1981): \emph{Graphics and Graphic Information Processing}.
      Berlin, Walter de Gruyter.
}
\examples{
data("townships")

## original data
pimage(townships)
criterion(townships, method = "moore_stress")


## reordered data
order <- reorder(townships, method ="bea")
pimage(townships[order$row, order$col])
criterion(townships, method = "moore_stress", order = order)

}
\keyword{datasets}
