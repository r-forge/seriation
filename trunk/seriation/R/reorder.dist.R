## reorder dist objects

reorder.dist <- function(x, method = NULL, control = NULL, ...){ 

    
    ## build-in methods
    methods <- c(
        "chen",    
        "tsp"    # standard
    ) 

    
    methodNr <- if(is.null(method)) 2
    else pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:", sQuote(method)))


    ## work horses
    if(methodNr == 1) {
        order <- .reorder_chen(x)
    }else if(methodNr == 2) {
        order <- .reorder_tsp(x, control)
    }

    if(is.null(attr(order, "method"))) 
        attr(order, "method") <- methods[methodNr]
   
    order_1d(order)
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
.reorder_tsp <- function(x, control = NULL){
    ## add a dummy city for cutting
    tsp <- insert_dummy(TSP(x), n = 1, label = "cut_here")
    tour <- solve_TSP(tsp, method = control$method, 
        control = control$control)
    order <- cut_tour(tour, cut = "cut_here", exclude_cut = TRUE)
    order
}

