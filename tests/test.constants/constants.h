#define ZERO 0
#define SMALL 10
#define NEGATIVE -1

#define UNSIGNED 17U
#define HEX 0x30

#define MACRO_EQUAL NEGATIVE

#define BASIC_MATH 60 * 60

/* These are borrowed from stdint.h */
#define INT8_C(v)    (v)
#define INT64_C(v)   (v ## LL)
#define UINT8_C(v)   (v ## U)

#define INT8_CONSTANT INT8_C(3)
#define INT64_CONSTANT_SMALL INT64_C(100)
// This one doesn't work:
// #define INT64_CONSTANT_BIG INT64_C(144674407370951615)
#define UINT8_CONSTANT UINT8_C(3)

#define STRING "help!"

#define EMPTY

#ifdef EMPTY
#define EMPTY_WAS_DEFINED 1
#endif

#define CHARACTER 'a'
