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


## registry helpers
.make_db_key <-
function(kind, name)
    paste(kind, name, sep = "_")

get_method_from_db <-
function(db, kind, name, msg)
{
    keys <- objects(db)
    ind <- pmatch(.make_db_key(kind, tolower(name)), tolower(keys))
    if(is.na(ind))
        stop(msg, call. = FALSE, domain = NA)
    
    db[[keys[ind]]]
}

put_method_into_db <-
function(db, kind, name, value)
{
    db[[.make_db_key(kind, name)]] <- value
}

list_methods_in_db <-
function(db, kind)
{
    pattern <- sprintf("^%s_", kind)
    sub(pattern, "",
        grep(pattern, objects(db), value = TRUE))
}


