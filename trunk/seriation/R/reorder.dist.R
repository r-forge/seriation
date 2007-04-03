## seriate dist objects

seriate.dist <- function(x, method = NULL, control = NULL, ...){ 
    
    ## build-in methods
    methods <- c(
        "tsp",    # standard
        "chen",    
        "mds"
    ) 
    
    methodNr <- if(is.null(method)) 1
    else pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:", sQuote(method)))

    workhorse <- 
    if(methodNr == 1) .seriate_tsp
    else if(methodNr == 2) .seriate_chen
    else if(methodNr == 3) .seriate_mds

    Order(order = workhorse(x, control), method = methods[methodNr])
}



## uses a sequence of correlation matrices and finds  the first matrix
## with rank 2. The elements are projected into the plane spanned by the 
## first two eigenvectors. All points are lying on a ellipse. The order
## of the elements on the ellipse is returned (see Chen 2002). 
.seriate_chen <- function(x, control){
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
    
    c(right,left)
}


## Bridge to package tsp 
.seriate_tsp <- function(x, control = NULL){
    ## add a dummy city for cutting
    tsp <- insert_dummy(TSP(x), n = 1, label = "cut_here")
   
    tour <- solve_TSP(tsp, method = control$method, 
        control = control$control)
    
    cut_tour(tour, cut = "cut_here", exclude_cut = TRUE)
}


## Multidimensional scaling
.seriate_mds <- function(x, control = NULL){
    if(is.null(control$method) || control$method == "cmdscale" ) {
        sc <- cmdscale(x, k=1)
        return(order(sc[,1]))
    
    }else if(control$method == "isoMDS"){
        sc <- isoMDS(x+1e-6, trace = FALSE, k=1)
        return(order(sc$points[,1]))
    
    }else if(control$method == "sammon") {
        sc <- sammon(x+1e-6, trace = FALSE, k=1)
        return(order(sc$points[,1]))

    }else stop("unknown method")

}


## generic for criterion
seriate <- function(x, ...) UseMethod("seriate")
seriate.default <- seriate.dist

