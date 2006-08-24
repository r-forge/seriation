# Cluster visualization by proximity matrix shading


# interface
cluproxplot <- function(x, labels = NULL, method = NULL,
    plot = TRUE, plot_options = NULL, ...) {

    res <- .arrange_proximity_matrix(x, labels = labels,
        method = method, ...)
    if(plot == TRUE) plot(res, plot_options)

    invisible(res)
}

# print for cluster_proximity_matrix
print.cluster_proximity_matrix <- function(x, ...) {
    d <- dim(x$x_reordered)
    k <- if(!is.null(x$k)) x$k else NA

    cat("Object of class", sQuote(class(x)))
    cat("\nmatrix dimensions:", d[1], "x", d[2])
    cat("\ndistance measure:", dQuote(x$diss_measure))
    cat("\nnumber of clusters k:", k, "\n")
    if(!is.null(x$k)) {
        cat("\ncluster description:\n")
        print(x$description)
    }

    cat("\nused seriation methods:\n")
    print(x$method)
}

# plot for cluster_proximity_matrix
plot.cluster_proximity_matrix <- function(x, plot_options = NULL, ...) {

    # default plot options
    options <- list(
        cluster_labels = TRUE, 
        averages    = TRUE, 
        lines       = TRUE, 
        silhouettes = TRUE,
        threshold   = NULL,
        main        = "cluster proximity plot",
        col         = hcl(h = 0, c = 0, l = seq(20, 95, len = 100)), 
        colorkey    = TRUE, 
        lines_col   = "black",
        newpage     = TRUE, 
        pop         = TRUE
    ) 


    # check and add the plot options
    if(!is.null(plot_options) && length(plot_options) != 0) {
        m <- pmatch(names(plot_options), names(options))

        if(any(is.na(m))) stop(paste("Unknown plot option:", 
                names(plot_options)[is.na(m)], "\n\t"))

        for (i in 1:length(m)) {
            options[[m[i]]] <- unlist(plot_options[i], use.names = FALSE)
        }

    } 

    # clear page
    if(options$newpage) grid.newpage()

    m       <- x$x_reordered
    k       <- x$k
    dim     <- dim(m)[1]
    labels  <- x$labels
    labels_unique <- unique(labels)

    if(is.null(x$sil)) options$silhouettes <- FALSE

    # color lower triangle panels with avg. dissimilarity
    if(options$averages == TRUE 
        && !is.null(x$cluster_distances) 
        && !is.null(labels)) {

        for(i in 1 : k) {
            for( j in 1 : k) {

                # check empty clusters
                if(is.na(labels_unique[i])) next
                if(is.na(labels_unique[j])) next

                # upper panels stay unchanged

                # do lower panels
                if(i > j) { 
                    m[labels == labels_unique[i], labels == labels_unique[j]] <- x$cluster_distances[i, j] 
                }

                # do diagonal
                if(i == j) {
                    block <- m[labels == labels_unique[i], 
                        labels == labels_unique[j]]

                    block[lower.tri(block, diag = FALSE)] <- x$cluster_distances[i, j]

                    m[labels == labels_unique[i],
                        labels == labels_unique[j]] <- block

                }
            }
        }
    }

    # remove entries > threshold

    if(options$silhouettes == FALSE) {
        pushViewport(viewport(layout = grid.layout(6, 3,
                    # space, image, space
                    widths = unit(c(2,0.7,2), c("lines", "snpc", "lines")),
                    # title, space, image, space, colorkey, space
                    heights = unit(c(2,1,0.7,1,1,2), 
                        c("lines", "lines", "snpc", "lines", "lines", "lines"))
                )))

        main_vp     <- viewport(layout.pos.col = 2, layout.pos.row = 1)
        image_vp    <- viewport(layout.pos.col = 2, layout.pos.row = 3)
        colorkey_vp <- viewport(layout.pos.col = 2, layout.pos.row = 5)

    }else{
        pushViewport(viewport(layout = grid.layout(6, 5,
                    # space, image, space, sil, space
                    widths = unit(c(2,0.6,1,0.2,2), 
                        c("lines", "snpc", "lines", "snpc", "lines")),
                    # title, space, image, space, colorkey, space
                    heights = unit(c(2,2,0.6,1,1,2), 
                        c("lines", "lines", "snpc", "lines", "lines", "lines"))
                )))

        main_vp     <- viewport(layout.pos.col = 2:4, layout.pos.row = 1)
        image_vp    <- viewport(layout.pos.col = 2,   layout.pos.row = 3)
        barplot_vp  <- viewport(layout.pos.col = 4,   layout.pos.row = 3)
        colorkey_vp <- viewport(layout.pos.col = 2,   layout.pos.row = 5)

    }


    # main
    pushViewport(main_vp)
    grid.text(options$main, gp = gpar(fontface = "bold", cex = 1.5))
    upViewport(1)

    pushViewport(image_vp)
    .grid_image(m, col = options$col, threshold = options$threshold)
    upViewport(1)

    if(options$colorkey == TRUE){
        pushViewport(colorkey_vp)
        .grid_colorkey(0, max(m), col = options$col, threshold = options$threshold)
        upViewport(1)
    }

    # plot cluster borders if we have labels and order
    if(!is.null(labels)) {

        cluster_width   <- (tabulate(labels)[labels_unique])
        cluster_cuts    <- cumsum(cluster_width) + 0.5

        if(options$cluster_labels == TRUE) {
            cluster_center <- cluster_cuts - cluster_width / 2

            seekViewport("image")
            #grid.text(labels_unique, x = cluster_center, 
                # y = unit(-1, "lines"), default.unit="native")

            # above the plot
            grid.text(labels_unique, x = cluster_center, 
                y = unit(1, "npc") + unit(1, "lines"), default.unit="native")
            # left of the plot
            grid.text(labels_unique, x = unit(-1, "lines"),
                y = cluster_center, default.unit="native")
            upViewport(2)
        }

        if(options$lines == TRUE){
            # draw lines separating the clusters
            cluster_cuts <- cluster_cuts[-length(cluster_cuts)]
            # remove last line

            seekViewport("image")
            for(i in 1:k) {

                grid.lines(
                    x = c(0.5, dim + 0.5), y = cluster_cuts[i], 
                    default.unit="native", gp = gpar(col = options$lines_col))

                grid.lines(
                    x = cluster_cuts[i], y = c(0.5, dim + 0.5), 
                    default.unit="native", gp = gpar(col = options$lines_col))

            }

            # draw diagonal
            grid.lines(x = c(0.5, dim + 0.5), y = c(0.5, dim + 0.5),
                default.unit="native", gp = gpar(col = options$lines_col))
            
            # redraw border
            grid.rect(x = 0,5 * dim, y = 0.5 * dim, width = dim - 1, 
                height =  dim - 1, default.units = "native", 
                gp= gpar(col = "black"))

            upViewport(2)

        }
    }

    if(options$silhouettes == TRUE) {

        # get and reorder silhouettes
        s <- x$sil[,"sil_width"]

        pushViewport(barplot_vp)
        .grid_barplot_horiz(s, xlab = "Silhouette width")
        upViewport(1)

    }

    if (options$pop == TRUE) popViewport(1)
    else upViewport(1)

}


# work horse
.arrange_proximity_matrix <- function(x, labels = NULL, method = NULL, ...) {

    
    # check if matrix is ok
    x_mat <- as.matrix(x)
    if(!isSymmetric(x_mat))
    stop("not implemented for non-symmetric matrices!")
    
    # make x dist
    if(!inherits(x, "dist")) x <- as.dist(x)
    diss_measure <- attr(x, "method")

    # set everything to NULL first
    k                   <- NULL           # number of clusters
    sil                 <- NULL
    labels_ordered      <- NULL
    cluster_distances   <- NULL
    used_method         <- c(NA, NA)
    names(used_method)  <- c("inter cluster", "intra cluster")

    # set default seriation
    if(is.null(method)) method[1] <- "murtagh"
    if(is.na(method[2]) && !is.null(labels)) method[2] <- method[1]
    
    if(is.na(method[1])) { 
        # no seriation
        order           <- NULL
        labels          <- NULL
        used_method[1]  <- NA
        
    }else if(is.null(labels)) {
        # seriate whole matrix if no labels are given
        order <- reorder(x_mat, method = method[1], ...)  
        
        if(!is.null(attr(order, "method"))) 
        used_method[1]      <- attr(order, "method")
        else used_method[1] <- method[1]

    }else if (!is.null(labels)){
        # seriate clusters for given labels
        if(length(labels) != dim(x_mat)[1]) stop("number of labels in",
            sQuote("labels"), "does not match dimensions of", sQuote("x"))


        # get number of clusters k
        k <- length(unique(labels))

        # reorder with average pairwise dissimilarites between clusters
        cluster_distances <- .cluster_dissimilarity(x_mat, labels)

        if(k>2) {
            cluster_order <- reorder(cluster_distances, 
                method = method[1], ... )
            
            if(!is.null(attr(cluster_order, "method"))) 
            used_method[1] <- attr(cluster_order, "method")
            else used_method[1] <- method[1]
        
        }else{
            cluster_order <- 1:k
        }



        # determine order for matrix from cluster order
        order <- c()

        if(is.na(method[2])) {
            # no intra cluster seriation
            for(i in 1 : k) {
                order <- c(order, which(labels == cluster_order[i]))
            }
            used_method[2] <- NA

        }else{
            # intra cluster seriation
            # calculate silhouette values for later use
            sil <- silhouette(labels, x)

            for(i in 1 : k) {
                take <- which(labels == cluster_order[i])

                # only seriate for >1 elements
                if(length(take) > 1) {

                    if(pmatch(tolower(method[2]), "silhouette width", 
                            nomatch = FALSE)) {
                        intra_order <-  order(sil[take, "sil_width"], 
                            decreasing = TRUE)
                        attr(intra_order, "method") <- "silhouette width"
                    }else{
                        block <- x_mat[take, take, drop = FALSE] 
                        intra_order <- reorder(block, method = method[2], ...) 
                    }

                    order <- c(order, take[intra_order])

                }else{
                    order <- c(order, take)
                }

            }
            
            if(!is.null(attr(intra_order, "method"))) 
            used_method[2] <- attr(intra_order, "method")
            else used_method[2] <- method[2]
        }


        # reorder cluster_distances for later
        cluster_distances  <- 
        cluster_distances[cluster_order, cluster_order]

        # prepare order for labels 
        labels          <- labels[order]

        # we might need unique labels at some point
        labels_unique   <-  unique(labels)


    }

    # reorder matrix
    if(!is.null(order)) x_mat <- x_mat[order, order]

    # prepare for return value
    cluster_description <- NULL

    if(!is.null(labels)) {
        # reorder silhouettes
        sil <- sil[order,]

        # calculate avg silhouettes
        avgSil <- sapply(labels_unique, function(x) 
            mean(sil[sil[,"cluster"]==x, "sil_width"])) 

        # generate description
        cluster_description = data.frame(
            position        = c(1 : k),
            label           = labels_unique, 
            size            = tabulate(labels)[labels_unique],
            avg_dissimilarity = diag(cluster_distances)[labels_unique],
            avg_silhouette_width = avgSil)
    }

    # clean order from names, etc.
    attributes(order) <- NULL
    
    result <- list(
        x_reordered     = x_mat, 
        labels          = labels, 
        method          = used_method, 
        k               = k, 
        cluster_distances =  cluster_distances,
        sil             = sil,
        order           = order, 
        diss_measure    = diss_measure,
        description     =  cluster_description)
    
    class(result) <- "cluster_proximity_matrix" 
    invisible(result)
}


# inter and intra cluster dissimilarity matrix from 
# a dissimilarity matrix plus labels
.cluster_dissimilarity <- function(x, labels) {
    if(class(x) != "matrix") x <- as.matrix(x)

    # kill self-dissimilarities (which are always 0)
    diag(x) <- NA

    k           <- length(unique(labels))
    diss_matrix <- matrix(nrow = k, ncol = k)

    # calculate avg. dissimilarity between clusters
    for(i in 1:k) {
        slice <- x[labels == i, , drop = FALSE]
        for(j in 1:i) {
            block <- slice[,labels == j, drop = FALSE]
            val <- mean(as.vector(block), na.rm = TRUE)

            # fix for clusters of size 1
            if(is.nan(val)) val <- 0

            diss_matrix[i, j] <- val
            diss_matrix[j, i] <- val
        }
    }

    diss_matrix
}


