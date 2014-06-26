module: portability
copyright: See LICENSE file in this distribution.

//======================================================================
// Module portability is a tiny OS dependent module which defines the
// preprocessor definitions and "standard" include directories which would be
// used by a typical C compiler for that OS.  It may, at some future date,
// also include behavioral switches for things like slot allocation or sizes
// of different sorts of numbers.
//
// This particular implementation of module portability corresponds to the
// compilation environment for an Intel x86 running Linux 2.x.x.
//======================================================================

define constant $melange-defines
  = #["const", "",
      "volatile", "",
      "restrict", "",
      "__restrict", "",
      "__STDC__", "",

      // The following six declarations should be removed someday, as soon as
      // we fix a bug in MINDY.
      //"__GNUC__", "2",
      //"__GNUC_MINPR__", "7",
      //"__signed__", "",
      //"__const", "",
      //"__CONSTVALUE", "",
      //"__CONSTVALUE2", "",

      // Parameterized macros which remove various GCC extensions from our
      // source code. The last item in the list is the right-hand side of
      // the define; all the items preceding it are named parameters.
      "__attribute__", #(#("x"), ""),
      "__signed__", "",
      "__inline__", "",
      "inline", "",
      "__inline", "",

      "__ELF__", "",
      "unix", "",
      "i386", "",
      "linux", "",
      "__unix__", "",
      "__i386__", "",
      "__linux__", "",
      "__unix", "",
      "__i386", "",
      "__linux", "",
      "__builtin_va_list", "void*"];

define constant $default-defines
  = concatenate($melange-defines, get-compiler-defines("gcc -dM -E - < /dev/null"));

define constant linux-include-directories
  = #["/usr/local/include",
      "/usr/include/linux",
      "/usr/include"];

add-to-include-path(linux-include-directories);
add-to-include-path(get-compiler-include-directories("gcc -print-file-name=include"));

// These constants should be moved here in the future.  Until the module
// declarations can be sufficiently rearranged to allow their definition
// here, they will remain commented out.  -- panda
//
// define constant c-type-size = unix-type-size;
// define constant c-type-alignment = unix-type-alignment;
// define constant $default-alignment :: <integer> = 4;


define constant $integer-size :: <integer> = 4;
define constant $short-int-size :: <integer> = 2;
define constant $long-int-size :: <integer> = 8;
define constant $longlong-int-size :: <integer> = 8;
define constant $char-size :: <integer> = 1;
define constant $float-size :: <integer> = 4;
define constant $double-float-size :: <integer> = 8;
define constant $long-double-size :: <integer> = 16;
define constant $enum-size :: <integer> = $integer-size;
define constant $pointer-size :: <integer> = 8;
define constant $function-pointer-size :: <integer> = $pointer-size;
