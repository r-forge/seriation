Townships <- as.matrix(read.table("townships.dat"))
colnames(Townships) <- gsub("\\.", " ",colnames(Townships))


save(Townships, file = "Townships.rda", compress = TRUE)
