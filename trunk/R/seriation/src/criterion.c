#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>

#include "lt.h"


/*
 * path length is in optimal.c
 */


/* 
 * least-square criterion
 * by M. Hahsler
 */

SEXP least_square_criterion(SEXP R_dist, SEXP R_order) {

    double sum = 0.0;
    int p = INTEGER(getAttrib(R_dist, install("Size")))[0];
    int *o = INTEGER_POINTER(R_order);
    double x = 0; 
    SEXP R_out;

    /* since d ist symmetric we only need to sum up half the matrix */
    for (int i = 1; i <= p; i++) {
        for (int j = 1; j < i; j++) {
            x = (REAL(R_dist)[LT_POS(p, o[i-1], o[j-1])] - abs(i-j));
            sum += x*x;
        }
    }
    sum *= 2;

    PROTECT(R_out = NEW_NUMERIC(1));
    REAL(R_out)[0] = sum; 
    UNPROTECT(1);

    return(R_out);
}


SEXP inertia_criterion(SEXP R_dist, SEXP R_order) {

    double sum = 0.0;
    int p = INTEGER(getAttrib(R_dist, install("Size")))[0];
    int *o = INTEGER_POINTER(R_order);
    double x = 0; 
    SEXP R_out;

    /* since d ist symmetric we only need to sum up half the matrix */
    for (int i = 1; i <= p; i++) {
        for (int j = 1; j < i; j++) {
            x = abs(i-j);
            sum += REAL(R_dist)[LT_POS(p, o[i-1], o[j-1])] * x*x;
        }
    }
    sum *= 2;

    PROTECT(R_out = NEW_NUMERIC(1));
    REAL(R_out)[0] = sum; 
    UNPROTECT(1);

    return(R_out);
}


