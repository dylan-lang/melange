
#define MANGLE(module, name) module ## name
#define DEFUN(name, module, args) extern void MANGLE(module, name) args

DEFUN(foo,, (int num));
DEFUN(bar, stdlib, (int num));

#define MULTICONCAT(x, y, z) x ## y ## z

MULTICONCAT(v, oi, d) baz1();
MULTICONCAT(vo, , id) baz2();
MULTICONCAT(vo, id, ) baz3();
MULTICONCAT(, vo, id) baz4();
MULTICONCAT(void, , ) baz5();
MULTICONCAT(, void, ) baz6();
MULTICONCAT(, , void) baz7();

#define DEFUN2(flags, type, name) flags type name ()

DEFUN2(extern, int, getpid);
DEFUN2(, extern int, foobar1);
DEFUN2(extern int, , foobar2);

#define __MATHCALL(function,suffix, args) extern double function ## suffix args 
__MATHCALL (acos,, (int __x));
