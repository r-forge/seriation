\name{bea}
\alias{bea}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Bond Energy Algorithm}
\description{
Permutes rows and columns of an array, in order to maximize proximity of
large-valued array elements.
}
\usage{
bea(a, istart = 0, jstart = 0)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{a}{data matrix to be analyzed.  The rows could represent observations
      and the columns variables (a two-way, two-mode array); or the rows and
      columns could both represent observations (a two-way, one-mode array).
      Missing values are not supported.  }
  \item{istart}{sequence number of first row to be placed; if not specified,
      then a row is arbitrarily chosen.}
  \item{jstart}{sequence number of first column to be placed; if not specified,
      then a row is arbitrarily chosen.}
}
\details{
This is a `non-destructive' approach to analyzing data, insofar as the
original data is not altered; it is only rearranged, in order to highlight
potentially interesting aspects of the data.  Subsequent runs of this
routine may improve the bond energy.

A row is arbitrarily placed; then rows are positioned one by one.  When this
is completed, the columns are treated similarly.  The overall procedure
amounts to two approximate traveling salesman problems, - one on the rows and
one on the columns.  The so-called `best insertion' strategy is used: rows
(or columns) are inserted into the current permuted list of rows (or columns).

This simple method has been used in operations research, production
engineering, marketing, and various other fields.  Arabie and Hubert (1990)
recommend that it be used with ratio scale data; and they question its use
with non-binary data if the objective is to find a seriation or
one-dimensional ordering of rows and columns.
}
\value{
List describing the reordering carried out:
\item{b}{row and column permuted array.}
\item{ib}{permutation of rows.}
\item{jb}{permutation of columns.}
\item{e}{`bond energy' of the permuted matrix, `b'.}
}
\references{
W.T. McCormick, P.J. Schweitzer and T.W. White,
Problem decomposition and data reorganization by a clustering technique,
Operations Research,
vol. 20, pp. 993-1009, Sept./Oct. 1972.

P. Arabie and L.J. Hubert,
The bond energy algorithm revisited,
IEEE Transactions on Systems, Man, and Cybernetics,
vol. 20, pp. 268-274, 1990.

P. Arabie, S. Schleutermann, J. Daws and L. Hubert,
Marketing applications of sequencing and partitioning of nonsymmetric
and/or two-mode matrices,
in W. Gaul and M. Schader, Eds.,
Data Analysis, Decision Support, \& Expert Knowledge Representation in
Marketing,
Springer Verlag, 1988, pp. 215-224.
}
\author{Fionn Murtagh}
%\seealso{}
\examples{
# set seed
set.seed(1)

# generate random data
a <- matrix(runif(100) > 0.6, ncol=20)
storage.mode(a) <- "integer" 

    
run1 <- bea(a)

# look at energy:
run1$e

# Redo, on basis of first run, to see if energy increases:
run2 <- bea(run1$b)
run2$e

# Remark: to have repeatable results, issue the `set.seed' before the `bea'
# command.  Now, reorder the rows and the columns once more:
run3 <- bea(run2$b)
run3$e

# Of course, sequencing of rows and columns of each run is relative to
# the array which was input.  Get `net' ordering of rows after third run:
run1$ib[run2$ib[run3$ib]]
run1$jb[run2$jb[run3$jb]]

# Plot the output as images:
def.par <- par(no.readonly = TRUE)
layout(matrix(c(1,2), 1, 2, byrow=TRUE), respect=TRUE)
pimage(a, main = "original")
pimage(bea(a)$b, main = "rordered")
par(def.par)
}
\keyword{cluster}% at least one, from doc/KEYWORDS
\keyword{optimize}% __ONLY ONE__ keyword per line
