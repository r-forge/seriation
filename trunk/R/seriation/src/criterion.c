#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>

#define LT_REAL(x, n, i, j)					\
  (i)<(j) ? REAL(x)[n*((i)-1) - (i)*((i)-1)/2 + (j)-(i)-1]	\
    : REAL(x)[n*((j)-1) - (j)*((j)-1)/2 + (i)-(j)-1]

/* 
 * LT_REAL to access a lower triangle matrix by C. Buchta 
 * modified by M. Hahsler 
 * x ... dist object
 * n ... number of observations (attribute "Size")
 * i,j ... column and row index 
 * 
 * Note: does not cover the case i==j!
 * /

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
      x = (LT_REAL(R_dist, p, o[i-1], o[j-1]) - abs(i-j));
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
      sum += LT_REAL(R_dist, p, o[i-1], o[j-1]) * x*x;
    }
  }
  sum *= 2;

  PROTECT(R_out = NEW_NUMERIC(1));
  REAL(R_out)[0] = sum; 
  UNPROTECT(1);
  
  return(R_out);
}


