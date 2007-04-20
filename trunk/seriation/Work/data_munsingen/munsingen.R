Munsingen <- as.matrix(read.table("munsinge.dat", skip = 2))
colnames(Munsingen) <- 1:ncol(Munsingen)

save(Munsingen, file = "Munsingen.rda", compress = TRUE)


