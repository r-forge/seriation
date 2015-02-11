\name{color_palettes}
\alias{col_br}
\alias{col_gr}
\alias{col_gray}
\alias{col_grey}
\title{Different Useful Color Palettes}
\description{
Defines several color palettes for \code{pimage}, \code{dissplot}
and \code{hmap}.
}
\usage{
col_br(n = 100, bias = 1)
col_gr(n = 100, bias = 1)
col_gray(n = 100, power = 1)
col_grey(n = 100, power = 1)
}
\arguments{
  \item{n}{ number of different colors produces. }
  \item{bias}{a positive number. Higher values give more widely 
    spaced colors at the high end.}
  \item{power}{ control parameter determining how luminance should be increased (1 = linear, 2 = quadratic, etc.).}
}
\details{
\code{col_br} creates a blue-red color palette.

\code{col_gr} creates a green-read color palette.

\code{col_gray} and \code{col_grey} creates gray scales.

See \code{colorRampPalette} to create your own color palettes.
}
\value{
A vector with \code{n} colors.
}
\seealso{
  \code{\link[grDevices]{colorRampPalette}},
  \code{\link{pimage}},
  \code{\link{dissplot}},
  \code{\link{hmap}}.
}
\author{Michael Hahsler}
\examples{
  pimage(rbind(1:100), key=TRUE)
  pimage(rbind(1:100), key=TRUE, col = col_br())
  pimage(rbind(1:100), key=TRUE, col = col_br(bias = 2))
  pimage(rbind(1:100), key=TRUE, col = col_gr())
}
\keyword{hplot}
