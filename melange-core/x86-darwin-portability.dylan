module: portability
copyright: See LICENSE file in this distribution.
           This code was produced by the Gwydion Project at Carnegie Mellon
           University.

//======================================================================
// Module portability is a tiny OS dependent module which defines the
// preprocessor definitions and "standard" include directories which would be
// used by a typical C compiler for that OS.  It may, at some future date,
// also include behavioral switches for things like slot allocation or sizes
// of different sorts of numbers.
//
// This particular implementation of module portability corresponds to
// the compilation environment for a MacOS X Macintosh using the Darwin BSD layer.
//======================================================================

define constant $melange-defines
  = #["_POSIX_C_SOURCE", "200809L",
      "MAC_OS_X_VERSION_MIN_REQUIRED", "1080"];

define constant $default-defines
  = concatenate($melange-defines,
                $gcc-or-clang-defines,
                get-compiler-defines("clang -arch i386 -dM -E - < /dev/null"));

// The undefinition of __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ is
// to work around an issue that otherwise happens when parsing the API availability
// header definitions.
define constant $default-undefines
  = #["__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__"];

// Set up the search path for .h files
// cc -E -v /dev/null
define constant macos-include-directories
  = #["/usr/local/include",
      "/usr/include"];

add-to-include-path(macos-include-directories);
add-to-include-path(get-compiler-include-directories("clang -print-file-name=include"));

*framework-paths* := #[ "/System/Library/Frameworks/", "/Library/Frameworks/", "~/Library/Frameworks/" ];


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
define constant $enum-size :: <integer> = $long-int-size;        // Some Apple header constants are longs!
define constant $pointer-size :: <integer> = 4;
define constant $function-pointer-size :: <integer> = $pointer-size;
