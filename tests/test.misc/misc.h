/* Start:
 * This tests a struct with a member of the same type
 * and the struct has a typedef and then a function
 * uses a pointer to that typedef type, then it was
 * previously generating multiple definitions for the
 * pointer type. */
typedef struct A {
  int a;
  int b;
  struct A *next;
} A;

void takes_a(A* a);
/* End. */
