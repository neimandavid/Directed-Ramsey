#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

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

int main (int argc, char** argv) {
  if (argc < 3) { printf ("c use as follows: ./decode FILE N\n"); }

  FILE *input = fopen (argv[1], "r");
  int n = atoi (argv[2]);

  int i, j, lit, max, tmp;

  max = n * (n-1) / 2;
  int sol[max + 1];
  for (i = 0; i < max; i++) sol[i] = -1;


  while (1) {
    tmp = fscanf (input, " v ");
    if (tmp == EOF) break;
    tmp = fscanf (input, " %i ", &lit);
    if (tmp == EOF) break;

    if (abs(lit) > max) continue;
    if (lit >= 0) sol[lit] = 1;
    else sol[-lit] = 0;
  }

  for (i = 1; i <= n; i++) {
    for (j = 1; j <= n; j++) {
      if (i == j) { printf ("0 "); continue; }
      int v, e = getEdge (i, j);
      if (e >= 0) v = sol[ e];
      else        v = 1 - sol[-e];
      if (v == -1) printf ("* ");
      else printf ("%i ", v); }
    printf ("\n"); }

}

