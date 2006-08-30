
/* LT_POS to access a lower triangle matrix by C. Buchta 
 * modified by M. Hahsler 
 * n ... number of rows/columns
 * i,j ... column and row index 
 * 
 * Note: does not cover the case i==j!
 */

#ifndef LT_POS
#define LT_POS(n, i, j)					\
  (i)<(j) ? n*((i)-1) - (i)*((i)-1)/2 + (j)-(i) -1	\
        : n*((j)-1) - (j)*((j)-1)/2 + (i)-(j) -1
#endif



