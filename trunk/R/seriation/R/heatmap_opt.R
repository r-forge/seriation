heatmap_opt <- function(x, dist_row = NULL, dist_col = NULL, ...) {
    if(!is.matrix(x)) x <- as.matrix(x)

    if(is.null(dist_row)) dist_row <- dist(x)
    if(is.null(dist_col)) dist_col <- dist(t(x))

    dend_col <- as.dendrogram(reorder(hclust(dist_col), dist_col, 
            method = "optimal"))
    dend_row <- as.dendrogram(reorder(hclust(dist_row), dist_row, 
            method = "optimal"))
    
    ## heatmap by default scales rows - maybe we don't want that!
    
    heatmap(x, Colv = dend_col, Rowv = dend_row, scale = "none", ...)
}
