/* FORTRAN Wrapper for R RNG */

#include <R.h>

void F77_SUB(getrngstate)(void) { GetRNGstate(); }
void F77_SUB(putrngstate)(void) { PutRNGstate(); }
void F77_SUB(unifrand)(float* x) { *x = (float) unif_rand(); }
