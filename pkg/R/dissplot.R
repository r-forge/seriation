## Cluster visualization by proximity matrix shading


## interface
dissplot <- function(x, labels = NULL, method = NULL,
    control = NULL, options = NULL) {

    ## make x dist
    if(!inherits(x, "dist")) {
        if(is.matrix(x) && isSymmetric(x)) x <- as.dist(x)
        else
            stop("Argument 'x' cannot safely be coerced to class 'dist'.")
    }
    
    res <- .arrange_dissimilarity_matrix(x, labels = labels,
        method = method, control = control)
   
    ## supress plot?
    plot <- if(is.null(options$plot)) TRUE else is.null(options$plot)
    if(plot) plot(res, options, gp = options$gp)

    invisible(res)
}

## print for cluster_dissimilarity_matrix
print.cluster_dissimilarity_matrix <-
function(x, ...)
{
    d <- attr(x$x_reordered, "Size")
    k <- if(!is.null(x$k)) x$k else NA

    cat(gettextf("object of class '%s'\n", class(x)))
    cat("matrix dimensions:", d, "x", d, "\n")
    cat(gettextf("dissimilarity measure: '%s'\n", x$diss_measure))
    cat("number of clusters k:", k, "\n")
    if(!is.null(x$k)) {
        cat("\ncluster description\n")
        print(x$description)
    }

    cat("\n")
    cat("used seriation methods\n")
    cat(gettextf("inter-cluster: '%s'\n", x$method$inter))
    cat(gettextf("intra-cluster: '%s'\n", x$method$intra))

    invisible(x)
}

## plot for cluster_dissimilarity_matrix
plot.cluster_dissimilarity_matrix <- function(x, options = NULL, ...) {
    
    m       <- as.matrix(x$x_reordered)
    k       <- x$k
    dim     <- attr(x$x_reordered, "Size")
    labels  <- x$labels
    labels_unique <- unique(labels)

    user_options <- options
    ## default plot options
    options <- list(
        cluster_labels = TRUE, 
        averages    = TRUE, 
        lines       = TRUE, 
        silhouettes = FALSE,
        threshold   = NULL,
        main        = paste("Dissimilarity plot:", 
            dim,"x",dim),
        col         = hcl(h = 0, c = 0, l = seq(20, 95, len = 100)), 
        colorkey    = TRUE, 
        lines_col   = "black",
        newpage     = TRUE, 
        pop         = TRUE,
        gp          = gpar()
    ) 

    ## check and add the plot options
    if(!is.null(user_options) && length(user_options) != 0) {
        o <- pmatch(names(user_options), names(options))

        if(any(is.na(o)))
            stop(sprintf(ngettext(length(is.na(o)),
                                  "Unknown plot option: %s",
                                  "Unknown plot options: %s"),
                         paste(names(user_options)[is.na(o)],
                               collapse = " ")))

        options[o] <- user_options    
    } 

    ## get grid options
    gp <- options$gp
    
    ## clear page
    if(options$newpage) grid.newpage()


    ## do we have silhouettes?
    if(is.null(x$sil)) options$silhouettes <- FALSE

    ## color lower triangle panels with avg. dissimilarity
    if(options$averages
        && !is.null(x$cluster_dissimilarities) 
        && !is.null(labels)) {

        for(i in 1 : k) {
            for( j in 1 : k) {

                ## check empty clusters
                if(is.na(labels_unique[i])) next
                if(is.na(labels_unique[j])) next

                ## upper panels stay unchanged

                ## do lower panels
                if(i > j) { 
                    m[labels == labels_unique[i], labels == labels_unique[j]] <- x$cluster_dissimilarities[i, j] 
                }

                ## do diagonal
                if(i == j) {
                    block <- m[labels == labels_unique[i], 
                        labels == labels_unique[j]]

                    block[lower.tri(block, diag = FALSE)] <- x$cluster_dissimilarities[i, j]

                    m[labels == labels_unique[i],
                        labels == labels_unique[j]] <- block

                }
            }
        }
    }

    if(!options$silhouettes) {
        pushViewport(viewport(layout = grid.layout(6, 3,
                    widths = unit.c(
                        unit(2, "lines"),                       # space
                        unit(1, "snpc") - unit(7, "lines"),     # image
                        unit(2, "lines")                        # space
                        ),
                    heights = unit.c(
                        unit(2, "lines"),                       # title
                        unit(1, "lines"),                       # space
                        unit(1, "snpc") - unit(7, "lines"),     # image
                        unit(1, "lines"),                       # space
                        unit(1, "lines"),                       # colorkey
                        unit(2, "lines")                        # space
                        )
                )))

        main_vp     <- viewport(layout.pos.col = 2, layout.pos.row = 1)
        image_vp    <- viewport(layout.pos.col = 2, layout.pos.row = 3)
        colorkey_vp <- viewport(layout.pos.col = 2, layout.pos.row = 5)

    }else{
        pushViewport(viewport(layout = grid.layout(6, 5,
                    widths = unit.c(
                        unit(2, "lines"),                       # space
                        unit(0.7, "snpc") - unit(2.5, "lines"), # image
                        unit(1, "lines"),                       # space
                        unit(0.3, "snpc") - unit(2.5, "lines"), # sil
                        unit(2, "lines")                        # space
                        ),
                    heights = unit.c(
                        unit(2, "lines"),                       # title
                        unit(2, "lines"),                       # space
                        unit(0.7, "snpc") - unit(2.5, "lines"), # image
                        unit(1, "lines"),                       # space
                        unit(1, "lines"),                       # colorkey
                        unit(2, "lines")                        # space
                        )
                )))

        main_vp     <- viewport(layout.pos.col = 2:4, layout.pos.row = 1)
        image_vp    <- viewport(layout.pos.col = 2,   layout.pos.row = 3)
        barplot_vp  <- viewport(layout.pos.col = 4,   layout.pos.row = 3)
        colorkey_vp <- viewport(layout.pos.col = 2,   layout.pos.row = 5)

    }


    ## main
    pushViewport(main_vp)
    gp_main             <- gp
    gp_main$cex         <- if(is.null(gp$cex)) 1.3 else gp$cex * 1.3
    gp_main$fontface    <- "bold"
    
    grid.text(options$main, gp = gp_main)
    upViewport(1)

    ## image
    pushViewport(image_vp)
    
    range_m <- range(m, na.rm = TRUE)
    if(!is.null(options$threshold)) m[m > options$threshold] <- NA
    
    .grid_image(m, col = options$col, zlim = range_m, gp = gp)
    upViewport(1)

    if(options$colorkey) {
        pushViewport(colorkey_vp)
        .grid_colorkey(range_m, col = options$col, 
            threshold = options$threshold, gp = gp)
        upViewport(1)
    }

    ## plot cluster borders if we have labels and order
    if(!is.null(labels)) {

        cluster_width   <- (tabulate(labels)[labels_unique])
        cluster_cuts    <- cumsum(cluster_width) + 0.5

        if(options$cluster_labels) {
            cluster_center <- cluster_cuts - cluster_width / 2

            seekViewport("image")

            ## above the plot
            grid.text(labels_unique, x = cluster_center, 
                      y = unit(1, "npc") + unit(1, "lines"),
                      default.units = "native",
                      gp = gp)
            ## left of the plot
            grid.text(labels_unique, x = unit(-1, "lines"),
                      y = cluster_center,
                      default.units = "native",
                      gp = gp)
            upViewport(2)
        }

        if(options$lines) {
            gp_lines        <- gp
            gp_lines$col    <- options$lines_col
            
            ## draw lines separating the clusters
            cluster_cuts <- cluster_cuts[-length(cluster_cuts)]
            ## remove last line

            seekViewport("image")
            for(i in 1:k) {

                grid.lines(
                    x = c(0.5, dim + 0.5), y = cluster_cuts[i], 
                    default.units = "native", gp = gp_lines)

                grid.lines(
                    x = cluster_cuts[i], y = c(0.5, dim + 0.5), 
                    default.units = "native", gp=gp_lines)

            }

            ## draw diagonal
            ##grid.lines(x = c(0.5, dim + 0.5), y = c(0.5, dim + 0.5),
                ##    default.unit="native", gp = gp_lines)
            
            ## redraw border
            grid.rect(x = 0,5 * dim, y = 0.5 * dim, width = dim - 1, 
                height =  dim - 1, default.units = "native", 
                gp = gp_lines)

            upViewport(2)

        }
    }

    if(options$silhouettes) {

        ## get and reorder silhouettes
        s <- x$sil[,"sil_width"]

        pushViewport(barplot_vp)
        .grid_barplot_horiz(s, xlab = "Silhouette width", gp = gp)
        upViewport(1)

    }

    if (options$pop)
        popViewport(1)
    else
        upViewport(1)

}


## work horse
.arrange_dissimilarity_matrix <- function(x, labels = NULL, method = NULL, 
    control = NULL) {

    ## x is already of class dist
    dim <- attr(x, "Size")
    diss_measure <- attr(x, "method")
    
    ## check labels
    if(!is.null(labels) && length(labels) != dim) 
        stop("Number of labels in 'labels' does not match dimensions of 'x'.")
    
    ## set everything to NULL first
    order               <- NULL
    k                   <- NULL             # number of clusters
    sil                 <- NULL
    avgSil              <- NULL
    labels_ordered      <- NULL
    labels_unique       <- NULL
    cluster_dissimilarities <- NULL
    used_method         <- list(inter_cluster = NA, intra_cluster = NA) 
    
    ## default is NULL which means use the default of reorder
    ## maybe we want to check if names inter and intra are ok
    if(class(method) != "list"){
        method <- list(inter = method, intra = method)
    }
    if(class(control[[1]]) != "list"){
        control <- list(inter = control, intra = control)
    }
        
    if(!is.null(method$inter) && 
        is.na(method$inter)) { 
        ## keep the matrix as is -- do not reorder
        labels          <- NULL
        ##order           <- NULL
        ##used_method$inter  <- NA
        
    }else if(is.null(labels)) {
        ## reorder whole matrix if no labels are given
        order <- seriate(x, method = method$inter, 
            control = control$inter)[[1]] 
        
        used_method$inter <- if(!is.null(attr(order, "method"))) 
            attr(order, "method") else method$inter

        order <- get_order(order)

    }else if (!is.null(labels)){
        ## reorder clusters for given labels
        ## get number of clusters k
        k <- length(unique(labels))

        ## reorder with average pairwise dissimilarites between clusters
        cluster_dissimilarities <- .cluster_dissimilarity(x, labels)

        if(k>2) {
            cluster_order <- seriate(as.dist(cluster_dissimilarities), 
                method = method$inter, control = control$inter)[[1]]
           
            used_method$inter <- if(!is.null(attr(cluster_order, "method"))) 
                attr(cluster_order, "method") else method$inter
       
            cluster_order <- get_order(cluster_order)
        }else{
            cluster_order <- 1:k
        }

        ## calculate silhouette values for later use
        sil <- cluster::silhouette(labels, x)

        ## determine order for matrix from cluster order
        order <- c()
        
        if(!is.null(method$intra) && 
            is.na(method$intra)) {
            ## no intra cluster ordering
            for(i in 1 : k) {
                order <- c(order, which(labels == cluster_order[i]))
            }
            ##used_method$intra <- NA

        }else{
            ## intra cluster order

            for(i in 1 : k) {
                take <- which(labels == cluster_order[i])

                ## only reorder for >1 elements
                if(length(take) > 1) {

                    if(is.character(method$intra) &&
                        pmatch(tolower(method$intra), "silhouette width", 
                            nomatch = FALSE)) {
                        intra_order <-  order(sil[take, "sil_width"], 
                            decreasing = TRUE)$both
                        
                        used_method$intra <- "silhouette width"
                    }else{
                        ## we use .rearrange_dist instead of permute
                        ## since we take only a subset!
                        block <- .rearrange_dist(x, take)
                        
                        intra_order <- seriate(block, method = method$intra, 
                            control = control$intra)[[1]]

                        used_method$intra <- 
                        if(!is.null(attr(intra_order, "method")))
                        attr(intra_order, "method") else method$intra
                    
                        intra_order <- get_order(intra_order)
                    }

                    order <- c(order, take[intra_order])

                }else{
                    order <- c(order, take)
                }

            }
        }


        ## reorder cluster_dissimilarities for later
        cluster_dissimilarities  <- 
        cluster_dissimilarities[cluster_order, cluster_order]

        ## prepare order for labels 
        labels          <- labels[order]

        ## we might need unique labels at some point
        labels_unique   <-  unique(labels)


    }

    ## reorder matrix
    if(!is.null(order)) x_reordered <- permute(x, order)
    else x_reordered <- x
    
    ## prepare for return value
    cluster_description <- NULL

    if(!is.null(labels)) {
        
        ## reorder silhouettes
        sil <- sil[order,]

        ## calculate avg silhouettes
        avgSil <- sapply(labels_unique, function(x) 
            mean(sil[sil[,"cluster"]==x, "sil_width"])) 

        ## generate description
        cluster_description = data.frame(
            position        = c(1 : k),
            label           = labels_unique, 
            size            = tabulate(labels)[labels_unique],
            avg_dissimilarity = diag(cluster_dissimilarities)[labels_unique],
            avg_silhouette_width = avgSil)
    }

    ## clean order from names, etc.
    attributes(order) <- NULL
    
    result <- list(
        x_reordered     = x_reordered, 
        labels          = labels, 
        method          = used_method, 
        k               = k, 
        cluster_dissimilarities =  cluster_dissimilarities,
        sil             = sil,
        order           = order, 
        cluster_order   = labels_unique,
        diss_measure    = diss_measure,
        description     =  cluster_description)
    
    class(result) <- "cluster_dissimilarity_matrix" 
    invisible(result)
}


## inter and intra cluster dissimilarity matrix from 
## a dissimilarity matrix plus labels
.cluster_dissimilarity <- function(x, labels) {
    if(class(x) != "matrix") x <- as.matrix(x)

    ## kill self-dissimilarities (which are always 0)
    diag(x) <- NA

    k           <- length(unique(labels))
    diss_matrix <- matrix(nrow = k, ncol = k)

    ## calculate avg. dissimilarity between clusters
    for(i in 1:k) {
        slice <- x[labels == i, , drop = FALSE]
        for(j in 1:i) {
            block <- slice[,labels == j, drop = FALSE]
            val <- mean(as.vector(block), na.rm = TRUE)

            ## fix for clusters of size 1
            if(is.nan(val)) val <- 0

            diss_matrix[i, j] <- val
            diss_matrix[j, i] <- val
        }
    }

    diss_matrix
}


