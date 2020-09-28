#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#define MAX	100

int n;

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
  int i, tmp, row = 0, m = 1;
  char c;

  int line[MAX];
  for (i = 0; i < MAX; i++) line[i] = -1;

  FILE* input = fopen (argv[1], "r");

  n = 1;
  while (1) {
    tmp = fscanf (input, "%c", &c);
    if (tmp == EOF) break;
    if (c == ' ') continue;
    if (c == '1') line[n++] = 1;
    if (c == '0') line[n++] = 0;
    if (c == '*') line[n++] = -1;
    if (c == '\n') {
      n--;
      for (i = m + 1; i <= n; i++) {
        if (line[i] == -1) continue;
        if (line[i] ==  0) printf ("-");
        printf("%i 0\n", getEdge (m, i)); }
      n = 1;
      m++;
    }
  }
}
