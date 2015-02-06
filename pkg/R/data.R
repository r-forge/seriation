### lines data set from iVAT paper

create_lines_data <- function(n=250) {
  n1 <- n/5*2
  n2 <- n/5
  n3 <- n/5*2
  
  x1 <- data.frame(x = runif(n1, -5, 5), y = rnorm(n1, mean = 2, sd = .1))
  x2 <- data.frame(x = runif(n2, -3, 3), y = rnorm(n2, mean = 0, sd = .1))
  x3 <- data.frame(x = runif(n3, -5, 5), y = rnorm(n3, mean = -2, sd = .1))
  
  x <- rbind(x1, x2, x3)
  x <- x[sample(nrow(x)),]
  rownames(x) <- 1:nrow(x)
  x
}

