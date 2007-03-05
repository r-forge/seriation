tab <- read.table("Irish.tab", na.strings=".", header= TRUE)
rownames(tab) <- tab[,1]
colnames(tab) <- gsub("\\.", " ",colnames(tab))
tab <- tab[,-1]

Irish <- as.matrix(tab)
save(Irish, file = "Irish.rda", compress = TRUE)
