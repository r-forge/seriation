Psych24 <- read.table("psych24c.dataframe", header = TRUE)

Psych24 <- as.matrix(Psych24)
rownames(Psych24) <- colnames(Psych24)

save(Psych24, file="Psych24.rda", compress = TRUE)

