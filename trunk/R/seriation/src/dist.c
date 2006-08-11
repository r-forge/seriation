
#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>

#define LT_REAL(x, n, i, j)					\
  (i)<(j) ? REAL(x)[n*((i)-1) - (i)*((i)-1)/2 + (j)-(i)-1]	\
    : REAL(x)[n*((j)-1) - (j)*((j)-1)/2 + (i)-(j)-1]

/* LT_REAL to access a lower triangle matrix by C. Buchta 
 * modified by M. Hahsler 
 * x ... dist object
 * n ... number of observations (attribute "Size")
 * i,j ... column and row index 
 * 
 * Note: does not cover the case i==j!
 * /


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
	
        if(o[i-1] == o[j-1]) LT_REAL(R_dist_out, n, i, j) = 0.0;	
	else LT_REAL(R_dist_out, n, i, j) = LT_REAL(R_dist, n,
	    o[i-1], o[j-1]);
      }
    }
    
    UNPROTECT(1);
    return R_dist_out;
}

