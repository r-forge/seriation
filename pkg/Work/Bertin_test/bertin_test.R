## tests for Bertinplot provided by G. Sawitzki

library(seriation)

#random matrices
nrow <- 5
ncol <- 3

BMunif <- matrix(runif(nrow*ncol), nrow, ncol)
colnames(BMunif) <- colnames(BMunif, do.NULL=FALSE)
rownames(BMunif) <- rownames(BMunif, do.NULL=FALSE)

bertinplot(BMunif)
bertinplot(BMunif, options=list(shading=TRUE))
bertinplot(BMunif, options=list(shading=TRUE, panel=panel.blocks))


BMnorm <- matrix(rnorm(nrow*ncol), nrow, ncol)
colnames(BMnorm) <- colnames(BMnorm, do.NULL=FALSE)
rownames(BMnorm) <- rownames(BMnorm, do.NULL=FALSE)
bertinplot(BMnorm)
bertinplot(BMnorm, options=list(panel=panel.circles))

bertinplot(BMnorm, options=list(panel=panel.circles, reverse=TRUE))
bertinplot(BMnorm, options=list(shading=TRUE))
bertinplot(BMnorm, options=list(shading=TRUE, panel=panel.blocks))
bertinplot(BMnorm, highlight=BMnorm>1)

Nrcases <- 7
# Test vectors, used to build a matrix
Bzero <- rep(0, Nrcases)
Bone <- rep(1, Nrcases)
Bmone <- rep(-1, Nrcases)
Binc <- (1:Nrcases)
Bdec <- (Nrcases:1)
Bstep <- c(Bmone[Binc < Nrcases/2], Bone[Binc >= Nrcases/2])
Bhat <- Bone; Bhat[(floor(Nrcases/3)+1):(Nrcases-floor(Nrcases/3)) ] <- 0.5
Bnazero <- rep(c(NA,0),length.out= Nrcases)
Bnanzero <- rep(c(NaN,0),length.out= Nrcases)
Binf <- rep(c(Inf,10,0,-10,-Inf),length.out= Nrcases)

# Basic test matrices
Brmatrix <- rbind(Bzero, Bone, Bmone, Binc, Bdec, Bstep, Bhat)
colnames(Brmatrix) <- colnames(Brmatrix,FALSE)

bertinplot(Brmatrix)
bertinplot(Brmatrix, options=list(panel=panel.circles))
## FIXME: this one fails!!!
bertinplot(Brmatrix, options=list(panel=panel.circles, reverse=TRUE))

## R may use internal housekeeping to keep matrix columns hogogeneous. Check!
## Use row matrix and column matrix for tests.
Bcmatrix <- cbind(Bzero, Bone, Bmone, Binc, Bdec, Bstep, Bhat)
rownames(Bcmatrix) <- rownames(Bcmatrix,FALSE)

bertinplot(Bcmatrix)

# Basic test matrices with random error
BrRndmatrix <- Brmatrix+rnorm(nrow(Brmatrix)*ncol(Brmatrix))

bertinplot(BrRndmatrix)


# Test matrices with IEEE specials
Brmatrixx <- rbind(Bzero, Bone, Bmone, Binc, Bdec, Bstep, Bhat, Bnazero,
	Bnanzero, Binf)

bertinplot(Brmatrixx)
bertinplot(Brmatrixx, options=list(shading=TRUE))
bertinplot(Brmatrixx, options=list(reverse=TRUE))
bertinplot(Brmatrixx, options=list(panel=panel.squares))

## FIXME: this one fails!!!
bertinplot(Brmatrixx, options=list(panel=panel.circles, reverse=TRUE))

Bcmatrixx <- cbind(Bzero, Bone, Bmone, Binc, Bdec, Bstep, Bhat, Bnazero,
	Bnanzero,Binf)

bertinplot(Bcmatrixx)


