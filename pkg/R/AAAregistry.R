## setup registries

## seriate
registry_seriate <- registry(registry_class="seriation_registry", 
  entry_class="seriation_method")

registry_seriate$set_field("kind", type = "character", 
  is_key = TRUE, index_FUN = match_partial_ignorecase)
registry_seriate$set_field("name", type = "character", 
  is_key = TRUE, index_FUN = match_partial_ignorecase)
registry_seriate$set_field("fun", type = "function", 
  is_key = FALSE)
registry_seriate$set_field("description", type = "character", 
  is_key = FALSE)


print.seriation_method <- function(x, ...) {
  writeLines(c(
    gettextf("name:        %s", x$name),
    gettextf("kind:        %s", x$kind),
    gettextf("description: %s", x$description)))
  invisible(x)
}


## criterion
registry_criterion <- registry(registry_class="criterion_registry", 
  entry_class="criterion_method")

registry_criterion$set_field("kind", type = "character", 
  is_key = TRUE, index_FUN = match_partial_ignorecase)
registry_criterion$set_field("name", type = "character", 
  is_key = TRUE, index_FUN = match_partial_ignorecase)
registry_criterion$set_field("fun", type = "function", 
  is_key = FALSE)
registry_criterion$set_field("description", type = "character", 
  is_key = FALSE)
registry_criterion$set_field("merit", type = "logical", 
  is_key = FALSE)


print.criterion_method <-function(x, ...) {
  writeLines(c(
    gettextf("name:        %s", x$name),
    gettextf("kind:        %s", x$kind),
    gettextf("description: %s", x$description),
    gettextf("merit:       %s", x$merit)))
  invisible(x)
}



