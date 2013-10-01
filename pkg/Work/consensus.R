library(seriation)
library(relations)


data("iris")
x <- as.matrix(iris[-5])
x <- x[sample(1:nrow(x)),]
d <- dist(x)


order <- list(
	BEA = seriate(d, method = "ARSA"),
	TSP = seriate(d, method = "TSP"),
	PCA = seriate(d, method = "MDS"))

o <- lapply(order, get_order)
o <- lapply(o, ranking)


e <- relation_ensemble(list=o)
r <- relation_consensus(e, method="SD/L")

cons_order <- order(relation_scores(r, decreasing = FALSE))

pimage(d, cons_order)
