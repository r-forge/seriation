#######################################################################
# seriation - Infrastructure for seriation
# Copyrigth (C) 2011 Michael Hahsler, Christian Buchta and Kurt Hornik
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
    

## define default colors

.sequential_pal <- function(n= 100, power = 1) 
  colorspace::sequential_hcl(n, c.=c(0), l=c(90,30), power = power)
#.sequential_pal <- rev(gray.colors(64)) 

.diverge_pal <- function(n = 100, power = 1) 
  colorspace::diverge_hcl(n, c = 100, l = c(30, 90), power = 1)
#.diverge_pal <- colorRampPalette(c("red", "black", "blue"))(100) 
