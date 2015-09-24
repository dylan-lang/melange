struct a {
  int a;
  float b;
};

struct b {
  char c;
  double d;
};

struct read_only {
  int a;
  float b;
};

#include "def_tni.h"
struct invisible_typedef {
  tni a;
};

struct array_slot {
  tni a[2];
};

