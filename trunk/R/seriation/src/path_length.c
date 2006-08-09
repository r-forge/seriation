
#include <R.h>
#include <Rdefines.h>

/* compute the lenght of an order, i.e. the sum of
 * the edge weights along the path defined by the
 * order.
 * 
 * note that the order is a tour with the leg between
 * the first and the last city omitted.
 *
 * ceeboo 2005
 */

static double orderLength(double *x, int *o, int n) {

    double v, z;
    int i, j, k;

    z = 0;	/* path length */
    i = o[0];
    for (k = 0; k < n-1; k++) {
	j = o[k+1];
	if (i > j)
	   v = x[i+j*(n-1)-j*(j+1)/2-1];
	else
	   if (i == j)
	      return NA_REAL;
           else
	      v = x[j+i*(n-1)-i*(i+1)/2-1];
	if (!R_FINITE(v))
	   return NA_REAL;
	z += v;
	i = j;
    }
	    
    return z; 
}

/* R wrapper 
 */

SEXP path_length(SEXP R_dist, SEXP R_order) {

    int n, k;
    int *o;
	
    SEXP R_obj;

    n = 1 + (int) sqrt(2 * LENGTH(R_dist));

    if (LENGTH(R_dist) < 1 || LENGTH(R_dist) != n*(n-1)/2)
       error("order_cost: invalid length");

    if (LENGTH(R_order) != n)
       error("order_length: \"dist\" and \"order\" do not match");

    o = Calloc(n, int);

    for (k = 0; k < n; k++)		/* offset to C indexing */
	o[k] = INTEGER(R_order)[k]-1;
    
    PROTECT(R_obj = NEW_NUMERIC(1));
    
    REAL(R_obj)[0] = orderLength(REAL(R_dist), o, n);
    Free(o);
    
    UNPROTECT(1);
    
    return R_obj;
}


/**/
