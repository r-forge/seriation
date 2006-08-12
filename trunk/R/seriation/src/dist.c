
#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>
#include "lt.h"

/* Reorder a dist object with a given order
 * by M. Hahsler
 */

SEXP reorder_dist(SEXP R_dist, SEXP R_order) {

    SEXP R_dist_out;
    int n = INTEGER(getAttrib(R_dist, install("Size")))[0];
    
    if (LENGTH(R_order) != n)
       error("\"dist\" and length of \"order\" does not match!");
    int *o = INTEGER_POINTER(R_order);

    PROTECT(R_dist_out = NEW_NUMERIC(LENGTH(R_dist)));
    
    for (int i = 1; i <= n; i++) {		
      for (int j = (i+1); j <=n; j++) {
	
        if(o[i-1] == o[j-1]) REAL(R_dist_out)[LT_POS(n, i, j)] = 0.0;	
	else REAL(R_dist_out)[LT_POS(n, i, j)] = REAL(R_dist)[LT_POS(n,
	    o[i-1], o[j-1])];
      }
    }
    
    UNPROTECT(1);
    return R_dist_out;
}

