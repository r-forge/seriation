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
    




col_gr <- function(n = 100, bias = 1)
  colorRampPalette(c("green", "black", "red"), bias = bias, space = "Lab")(n)

### Lab looks a little purple here!
col_br <- function(n = 100, bias = 1) 
  colorRampPalette(c("blue", "white", "red"), bias = bias)(n)

col_gray <- function(n= 100, power = 1) 
  colorspace::sequential_hcl(n, c.=c(0), l=c(95, 40), power = power)
col_grey <- col_gray


## define default colors
.sequential_pal <- col_gray
.diverge_pal <- function(n = 100, power = 1) col_br(n, power)
