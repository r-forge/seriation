#######################################################################
# seriation - Infrastructure for seriation
# Copyrigth (C) 2011 Michael Hahsler, Christian Buchta and Kurt Hornik
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

seriation_dist <- function(x, method="kendall") {
  if(!is.matrix(x)) x <- t(sapply(x, function(o) get_rank(o)))
  
  method <- match.arg(tolower(method), 
    c("spearman", "kendall", "manhattan", "euclidean"))
  
  switch(method,
    spearman = as.dist(1-abs(cor(t(x), method="spearman"))),
    kendall = as.dist(1-abs(cor(t(x), method="kendal"))),
    ### Manhattan == Spearman's Foot rule  
    manhattan = .find_best(dist(.add_rev(x), method="manhattan")),
    euclidean = .find_best(dist(.add_rev(x), method="euclidean")),
  )
}

.add_rev <- function(x) {
  n <- nrow(x)
  rn <- rownames(x)
  x <- rbind(x, x[,ncol(x):1])
  rownames(x) <- c(rn, paste(rn, "_rev", sep=""))
  x
}  

.find_best <- function(d) {
  ### find smallest values
  m <- as.matrix(d)
  n <- nrow(m)/2
  m1 <- m[1:n, 1:n]
  m2 <- m[(n+1):(2*n), (n+1):(2*n)]
  m3 <- m[1:n, (n+1):(2*n)]
  m4 <- m[(n+1):(2*n), 1:n]
  as.dist(pmin(m1,m2,m3,m4))
}

  
