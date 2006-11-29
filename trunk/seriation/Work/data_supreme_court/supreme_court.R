Supreme <- read.table("supreme_court.dat", header = TRUE)

Supreme <- as.matrix(Supreme)
rownames(Supreme) <- colnames(Supreme)

