#include "assMatrix.h"

SEXP csc_subset(SEXP x, SEXP i, SEXP j)
{
    SEXP val;
    int nj = 0, u = 0, nnz = 0,
	    h, k, ii, jj, ind,  maxnz, 
	    *dims, *ndims, *is, *xi, *xp, *zi, *zp;
    double *xx, *zx;
    
    PROTECT(val = NEW_OBJECT(MAKE_CLASS("cscMatrix")));
    dims = INTEGER(GET_SLOT(x, install("Dim")));
    xi = INTEGER(GET_SLOT(x, install("i")));
    xp = INTEGER(GET_SLOT(x, install("p")));
    xx = REAL(GET_SLOT(x, install("x")));	    
	    
    ndims = Calloc(2, int);
    ndims[0] = LENGTH(i);
    ndims[1] = LENGTH(j);
    maxnz = ndims[0]*ndims[1];
    SET_SLOT(val, install("Dim"), allocVector(INTSXP, 2));
    Memcpy(INTEGER(GET_SLOT(val, install("Dim"))), ndims, 2);
    zi = Calloc(maxnz, int); zx = Calloc(maxnz, double);
    zp = Calloc(ndims[1]+1, int); is = Calloc(dims[0], int);
    for (k = 0; k < dims[0]; k++)
    {
	is[k] = 0;
	for (h = 0; h < ndims[0]; h++)
	    {
		ii = INTEGER(i)[h];
		if (k == ii) {
		    is[k] = u;
		    u++;
		    break;
		}
	    }
    }
    for (k = 0; k < dims[1]; k++) {
	for (h = 0; h < ndims[1]; h++) {
	    jj = INTEGER(j)[h];
	    if (k == jj) {
		zp[nj] = nnz;
		nj++;
		for (ind = xp[k]; ind < xp[k+1]; ind++) {
		    for (h = 0; h < ndims[0]; h++) {
			ii = INTEGER(i)[h];
			if (xi[ind] == ii) {
			    zx[nnz] = xx[ind];
			    zi[nnz] = is[ii];
			    nnz++;
			    break;
			}
		    }
		}
		break;
	    }
	}
    }
    zp[nj] = nnz;
    nj++;
    SET_SLOT(val, install("p"), allocVector(INTSXP, nj));
    Memcpy(INTEGER(GET_SLOT(val, install("p"))), zp, nj);
    SET_SLOT(val, install("i"), allocVector(INTSXP, nnz));
    Memcpy(INTEGER(GET_SLOT(val, install("i"))), zi, nnz);
    SET_SLOT(val, install("x"), allocVector(REALSXP, nnz));
    Memcpy(REAL(GET_SLOT(val, install("x"))), zx, nnz);
    Free(zi); Free(zx); Free(is); Free(zp);Free(ndims);
    UNPROTECT(1);
    return val;
}

