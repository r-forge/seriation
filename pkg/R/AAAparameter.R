#######################################################################
# Code to check parameter/control objects
# Copyrigth (C) 2011 Michael Hahsler
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
    

## helper to parse parameter lists with defaults

.get_parameters <- function(parameter, defaults) {
  defaults <- as.list(defaults)
  parameter <- as.list(parameter)
  
  ## add verbose
  if(is.null(defaults$verbose)) defaults$verbose <- FALSE
  
  if(length(parameter) != 0) {
    o <- pmatch(names(parameter), names(defaults))
    
    ## unknown parameter
    if(any(is.na(o))){
      cat("Available parameter (with default values):\n")
      #print(defaults)
      cat(rbind(names(defaults)," = ", gsub("\n"," ",as.character(defaults))), 
        sep=c("\t"," ","\n"))
      
      stop(sprintf(ngettext(length(is.na(o)),
        "Unknown parameter: %s",
        "Unknown parameters: %s"),
        paste(names(parameter)[is.na(o)],
          collapse = " ")), call. = FALSE)
    }
    
    defaults[o] <- parameter
  }

  if(defaults$verbose) {
    cat("Used parameters:\n")
    #print(defaults)
    cat(rbind(names(defaults)," = ", gsub("\n"," ",as.character(defaults))), 
      sep=c("\t"," ","\n"))
  }
  
  defaults
}
