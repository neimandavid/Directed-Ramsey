#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

//#define SBP

#define COMPACT

#define OFFSET	n

int n, k;

int getEdge (int a, int b) {
  assert (a != b);
  assert (a >  0);
  assert (b >  0);
  int min = a, max = b;
  if (min > max) { min = b; max = a; }

  int res = min + (max - 2) * (max - 1) / 2;

  if (a < b) return res;
  return -res;
}

int getTriangle (int a, int b, int c) {
  assert (a != b);
  assert (a != c);
  assert (b != c);
  assert (a >  0);
  assert (b >  0);
  assert (c >  0);
  int min = a, mid = b, max = c, swap;
  if (min > mid) { min = b;   mid = a; }
  if (min > max) { max = min; min = c; }
  if (mid > max) { swap = max; max = mid; mid = swap; }

  int res = min + OFFSET * (OFFSET-1) / 2;
  res += (mid - 2) * (mid - 1) / 2;
  res += (max - 3) * (max - 2) * (max - 1) / 6;

  return res;
}

void printClause (int* order) {
  int a, b, c;

  for (a = 0; a < k; a++)
    for (b = a + 1; b < k; b++)
      for (c = b + 1; c < k; c++) {
        printf ("%i ", getTriangle (order[a], order[b], order[c])); }
  printf ("0 \n");
}

void extendRec (int* order, int size) {
  if (size == k) printClause (order);
  else {
    int i;
    int start = 0;
    if (size > 0) start = order[size-1];
    for (i = start; i < n; i++) {
        order[size] = i + 1;
        extendRec (order, size+1);
    }
  }
}

int main (int argc, char** argv) {
   assert (argc > 2);
   n = atoi (argv[1]);
   k = atoi (argv[2]);

   int a, b, c;
   int *order = malloc (sizeof (int) * n);

   int nVar = OFFSET * (OFFSET-1) / 2 + n * (n-1) * (n-2) / 6;
   unsigned long long nCls = 1;
   for (a = n; a > k; a--) { nCls *= a; nCls /= (n - a + 1); }
#ifdef COMPACT
   nCls += n * (n-1) * (n-2) / 2;
#else
   nCls += n * (n-1) * (n-2);
#endif

#ifdef SBP
   nCls += n-2;
#endif
   printf ("p cnf %i %llu\n", nVar, nCls);

#ifdef SBP
   // basic symmetry breaking
   for (a = 2; a < n; a++)
     printf ("%i %i 0\n", -getEdge (1,a), getEdge (1, a+1));
#endif
   // triangle definitions
   for (a = 1; a <= n; a++)
     for (b = a+1; b <= n; b++)
       for (c = b+1; c <= n; c++) {
         printf ("%i %i %i 0\n", -getTriangle (a, b, c), -getEdge (a,b), getEdge (b,c));
         printf ("%i %i %i 0\n", -getTriangle (a, b, c), -getEdge (b,c), getEdge (c,a));
         printf ("%i %i %i 0\n", -getTriangle (a, b, c), -getEdge (c,a), getEdge (a,b));
#ifndef COMPACT
         printf ("%i %i %i 0\n", -getTriangle (a, b, c), -getEdge (a,b), getEdge (c,a));
         printf ("%i %i %i 0\n", -getTriangle (a, b, c), -getEdge (c,a), getEdge (b,c));
         printf ("%i %i %i 0\n", -getTriangle (a, b, c), -getEdge (b,c), getEdge (a,b));
#endif
       }

   extendRec (order, 0);
}
