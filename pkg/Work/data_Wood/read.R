dat <- read.table("wood.txt", header = TRUE)
rownames(dat) <- dat[,1]
dat <- dat[,-1]

Wood <- as.matrix(dat)
save(Wood, file="Wood.rda")
dim(Wood)