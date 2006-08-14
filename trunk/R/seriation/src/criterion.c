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


SEXP ar(SEXP R_dist, SEXP R_order, SEXP R_which) {

    /* 
     * which indicated the weighing scheme
     * 1 ... no weighting (i)
     * 2 ... weighted by abs. deviations (s)
     * 3 ... weighted version of 2 (w)
     */

    
    double sum = 0.0;
    int p = INTEGER(getAttrib(R_dist, install("Size")))[0];
    int *o = INTEGER_POINTER(R_order);
    int which = INTEGER(R_which)[0];
    double w = 1.0;
    
    double d_ij = 0;
    double d_ik = 0;
    
    SEXP R_out;


    for (int i = 3; i <= p; i++) {
        for(int k = 2; k < i; k++) {
            d_ik = REAL(R_dist)[LT_POS(p, i, k)];
            
            for(int j = 1; j < k; j++) {
                d_ij = REAL(R_dist)[LT_POS(p, i, j)];

                /* calculate weights */
                if(which == 2) w = abs(d_ij - d_ik);
                if(which == 3) w = abs(j-k) * abs(d_ij - d_ik);

                if(d_ij < d_ik) sum += w;
            }
        }
    }
                     
    for (int i = 1; i <= (p-2); i++) {
        for(int j = i+1; j <= (p-1); j++) {
            d_ij = REAL(R_dist)[LT_POS(p, i, j)];
            for(int k = j+1; k <= p; k++) {
                d_ik = REAL(R_dist)[LT_POS(p, i, k)];

                /* calculate weights */
                if(which == 2) w = abs(d_ij - d_ik);
                if(which == 3) w = abs(j-k) * abs(d_ij - d_ik);

                if(d_ij > d_ik) sum += w; 
            }
        }
    }

    PROTECT(R_out = NEW_NUMERIC(1));
    REAL(R_out)[0] = sum; 
    UNPROTECT(1);

    return(R_out);
}


