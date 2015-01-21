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

seriation_dist<- function(x, method="kendall") {
  .lget_rank <- function(x) t(sapply(x, get_rank))
  
  method <- match.arg(tolower(method), 
    c("spearman", "kendall", "manhattan", "euclidean"))
  
  switch(method,
    spearman = as.dist(1-abs(cor(t(.lget_rank(x)), method="spearman"))),
    kendall = as.dist(1-abs(cor(t(.lget_rank(x)), method="kendal"))),
    ### Manhattan == Spearman's footrule  
    #manhattan = .find_best(dist(.add_rev(x), method="manhattan")),
    manhattan = dist(.lget_rank(seriation_align(x)), method="manhattan"),
    #euclidean = .find_best(dist(.add_rev(x), method="euclidean")),
    euclidean = dist(.lget_rank(seriation_align(x)), method="euclidean")
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

  
seriation_align <- function(x, method = "manhattan") {
    n <- length(x)
    
    ## add reverse order
    os <- append(x, lapply(x, rev))
    rs <- t(sapply(os, function(o) get_rank(o)))
    d <- dist(rs, method=method)
    m <- as.matrix(d)
    diag(m) <- NA
    
    ## find closest pair
    take <- which(m == min(m, na.rm = TRUE), arr.ind = TRUE)[1,]
    
    ## mark taken
    m[, take] <- NA
    ## mark complements taken
    m[, (take+n) %% (2*n)] <- NA

    while(length(take) < n) {
      t2 <- which(m[take,] == min(m[take,], na.rm = TRUE), arr.ind = TRUE)[1, 2]
      take <- append(take, t2)
      m[, t2] <- NA
      m[, (t2+n) %% (2*n)] <- NA
    }
  
    os[take]
}

