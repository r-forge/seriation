## reorder dist objects

reorder.dist <- function(x, method = NULL, options = NULL,...){ 

    
    ## build-in methods
    methods <- c(
        "chen",         # standard
        "tsp") 

    
    methodNr <- if(is.null(method)) 1
    else pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:", sQuote(method)))


    ## work horses
    if(methodNr == 1) {
        order <- .reorder_chen(x)
    }else if(methodNr == 2) {
        order <- .reorder_tsp(x, options)
    }

    if(is.null(attr(order, "method"))) 
        attr(order, "method") <- methods[methodNr]
    
    ##class(order) <- "order"
    order
}



## uses a sequence of correlation matrices and finds  the first matrix
## with rank 2. The elements are projected into the plane spanned by the 
## first two eigenvectors. All points are lying on a ellipse. The order
## of the elements on the ellipse is returned (see Chen 2002). 
.reorder_chen <- function(x){
    x <- as.matrix(x)
    
    rank <- qr(x)$rank

    ## find the first correlation matrix of rank 2  
    n <- 0
    while(rank > 2){
        x <- cor(x)
        n <- n + 1
        rank <- qr(x)$rank
    }

    ## project the matrix on the first 2 eigenvectors
    e <- eigen(x)$vectors[,1:2]

    ## extract the order
    ## chen says that he uses the one of the two possible cuts
    ## that separate the points at rank 1. Since the points just 
    ## separate further towards right and left, cutting on the vertical
    ## axis of the ellipse yields the same result.

    right <- which(e[,1] >= 0)
    right <- right[order(e[right,2], decreasing = TRUE)]
    left <- which(e[,1] < 0)
    left <- left[order(e[left,2])]
    o <- c(right,left)

    o
}


## TSPs
## Bridge to package tsp 
.reorder_tsp <- function(x, options = NULL){
    tour <- solve_TSP(TSP(x), method = options$method, 
        options = options$options)
    order <- .cut_tsp(tour, x)
    attributes(order) <- attributes(tour)
    order
}

## optimal cut helper
## To find the cutting point in the tour, typically a dummy city with
## equal distance to every other city is added. The dummy city is then
## the optimal cutting place.
## However, this would require to manipulate the distance matrix. 
## Therefore, we just cut the tour between the most distant cities 
## which should give the same result.
.cut_tsp <- function(order, x) {
    if(!is.matrix(x)) x <- as.matrix(x)
    
    maxDist <- 0.0
    cut <- 0
    for(i in 1:(length(order)-1)) {
        if(x[order[i], order[i+1]] > maxDist) {
            maxDist <- x[order[i], order[i+1]]
            cut <- i
        }
    }
    if(x[order[length(order)], order[1]] > maxDist) {
        cut <- 0
    }

    if(cut > 0) order <- c(order[(cut+1):length(order)], order[1:cut])

    order
}

