module: portability
copyright: See LICENSE file in this distribution.
           This code was produced by the Gwydion Project at Carnegie Mellon
           University.  If you are interested in using this code, contact
           "Scott.Fahlman@cs.cmu.edu" (Internet).

//======================================================================
// Module portability is a tiny OS dependent module which defines the
// preprocessor definitions and "standard" include directories which would be
// used by a typical C compiler for that OS.  It may, at some future date,
// also include behavioral switches for things like slot allocation or sizes
// of different sorts of numbers.
//
// This particular implementation of module portability corresponds to
// the compilation environment for a Windows/NT box using the
// Microsoft Visual C++ compiler.
//======================================================================

define constant $default-defines
  = #["const", "",
      "volatile", "",
      "restrict", "",
      "__restrict", "",
      "_MSC_VER", "1020",
      "_M_IX86", "400",
      // The rest of these, I'm not sure the compiler defines, but
      // they certainly are handy
      "WIN32", "",
      "_WIN32", "1",
      "__cdecl", "",
      "_cdecl", "",
      "__STDC__", "",
      "_POSIX_", "",
      "__int64", "long long",
      "__attribute__", #(#("x"), ""),
      "__declspec", #(#("x"), ""),
      "__fastcall", "",
      "__stdcall", "",
      "inline", "",
      "_inline", "",
      "__inline", "",
      "__extension__", "",
      "__builtin_va_list", "void*"];

define constant $default-undefines = #[];

// Set up the search path for .h files
begin
  let include-env-variable = environment-variable("include") | "";

  // Translate backslashes to front slashes, because if we try to use
  // backslashes in string literals (esp. inside of a "c-include"
  // statement), it does bad things.
  let include-env-variable = replace-substrings(include-env-variable, "\\\\", "/");

  let include-dirs = split(include-env-variable, ';');
  add-to-include-path(include-dirs);
end;


// These constants should be moved here in the future.  Until the module
// declarations can be sufficiently rearranged to allow their definition
// here, they will remain commented out.  -- panda
//
// define constant c-type-size = unix-type-size;
// define constant c-type-alignment = unix-type-alignment;
// define constant $default-alignment :: <integer> = 4;


define constant $integer-size :: <integer> = 4;
define constant $short-int-size :: <integer> = 2;
define constant $long-int-size :: <integer> = 4;
define constant $longlong-int-size :: <integer> = 8;
define constant $char-size :: <integer> = 1;
define constant $float-size :: <integer> = 4;
define constant $double-float-size :: <integer> = 8;
define constant $long-double-size :: <integer> = 16;
define constant $enum-size :: <integer> = $integer-size;
define constant $pointer-size :: <integer> = 4;
define constant $function-pointer-size :: <integer> = $pointer-size;
