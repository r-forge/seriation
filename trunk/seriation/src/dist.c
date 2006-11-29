#include <R.h>
#include <Rinternals.h>

#include "lt.h"

/* 
 * Reorder a dist object with a given order
 * Beware: all checking and attribute stuff has to be done in the R wrapper
 */

SEXP reorder_dist(SEXP R_dist, SEXP R_order) {

    SEXP R_dist_out;
     
    int n = INTEGER(getAttrib(R_dist, install("Size")))[0];
    int n_out = LENGTH(R_order);
    int *o = INTEGER(R_order);

    PROTECT(R_dist_out = allocVector(REALSXP, n_out*(n_out-1)/2));

    for (int i = 1; i <= n_out; i++) {		
        for (int j = (i+1); j <=n_out; j++) {

            if(o[i-1] == o[j-1]) REAL(R_dist_out)[LT_POS(n_out, i, j)] = 0.0;	
            else REAL(R_dist_out)[LT_POS(n_out, i, j)] = 
                REAL(R_dist)[LT_POS(n, o[i-1], o[j-1])];
        }
    }

    UNPROTECT(1);
    return R_dist_out;
}

