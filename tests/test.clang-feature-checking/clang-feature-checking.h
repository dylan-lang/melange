#if __has_builtin(__builtin_trap)
  int builtin(void);
#endif

#if __has_feature(cxx_rvalue_references)
  int feature(void);
#endif

#if __has_extension(cxx_rvalue_references)
  int extension(void);
#endif

#if __has_cpp_attribute(clang::fallthrough) || 1
  int cpp_attribute(void);
#endif

#if __has_attribute(always_inline)
  int attribute(void);
#endif

#if __has_declspec_attribute(dllexport)
  int declspec_attribute(void);
#endif

#if __is_identifier(__wchar_t)
  int identifier(void);
#endif

#if __has_include(<sys/time.h>)
  int has_include(void);
#endif

#if __has_include_next(<xpc/xpc-all.h>)
  int has_include_next(void);
#endif
