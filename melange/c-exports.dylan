module: dylan-user
copyright: Copyright (C) 1994, 1996, Carnegie Mellon University
	   All rights reserved.
	   This code was produced by the Gwydion Project at Carnegie Mellon
	   University.  If you are interested in using this code, contact
	   "Scott.Fahlman@cs.cmu.edu" (Internet).
rcs-header: $Header: 

//======================================================================
//
// Copyright (c) 1994, 1996  Carnegie Mellon University
// All rights reserved.
//
//======================================================================

define library melange-c
  use dylan;
  use string-extensions;
  use collection-extensions;
  use regular-expressions;
  use table-extensions;
  use streams;
  use standard-io;
  use format;
  export multistring-match, c-lexer, c-declarations, portability;
end library melange-c;

define module multistring-match
  use dylan;
  use extensions;
  export
#if (~mindy)
    multistring-checker-definer, multistring-positioner-definer,
#endif
    make-multistring-positioner, make-multistring-checker
end module multistring-match;

define module c-lexer
  use dylan;
  use extensions;
  use table-extensions, exclude: {<string-table>};
  use self-organizing-list;
  use string-conversions;
  use regular-expressions;
  use substring-search;
  use character-type;
  use streams;
  use multistring-match;
  create cpp-parse;
  export
    *handle-//-comments*,
    <tokenizer>, cpp-table, cpp-decls, <token>, token-id, generator,
    <simple-token>, <reserved-word-token>, <punctuation-token>,
    <literal-token>, <ei-token>, <name-token>, <type-specifier-token>,
    <identifier-token>, <integer-token>, <struct-token>, <short-token>,
    <long-token>, <int-token>, <char-token>, <signed-token>, <unsigned-token>,
    <float-token>, <double-token>, <void-token>, <union-token>, <enum-token>,
    <minus-token>, <tilde-token>, <bang-token>, <alien-name-token>,
    <macro-parse-token>, <cpp-parse-token>, string-value, value, parse-error,
    unget-token, add-typedef, get-token, include-path, check-cpp-expansion,
    open-in-include-path
end module c-lexer;

define module portability
  use dylan;
  use c-lexer, import: {include-path, *handle-//-comments*};
  use system, import: {getenv};  // win32 only
  use regular-expressions;       // win32 only			  
  export
    $default-defines,
    $enum-size,
    $pointer-size, $function-pointer-size,
    $integer-size, $short-int-size,
    $long-int-size, $char-size,
    $float-size, $double-float-size,
    $long-double-size;
end module portability;

define module c-parse
  use dylan;
  use extensions;
  use self-organizing-list;
  use c-lexer;
  use streams;
  use format;
  use standard-io;
  create
    <parse-state>, <parse-file-state>, <parse-type-state>, <parse-cpp-state>,
    <parse-macro-state>, tokenizer, verbose, verbose-setter,
    push-include-level, pop-include-level, objects, process-type-list,
    process-declarator, declare-objects, make-struct-type, c-type-size,
    add-cpp-declaration, unknown-type, <declaration>, <arg-declaration>,
    <varargs-declaration>, <enum-slot-declaration>, constant-value,
    <integer-type-declaration>, true-type, make-enum-slot;
  export
    parse, parse-type, parse-macro;
end module c-parse;

define module c-declarations
  use dylan;
  use extensions, exclude: {format};
  use table-extensions, exclude: {<string-table>};
  use regular-expressions;
  use streams;
  use format;

  // We completely encapsulate "c-parse" and only pass out the very few 
  // objects that will be needed by "define-interface".  Note that the 
  // classes are actually defined within this module but are exported
  // from c-parse.
  use c-parse, export: {<declaration>, <parse-state>, parse, parse-type,
			constant-value, true-type};

  use c-lexer;			// Tokens are used in process-type-list and
				// make-struct-type
  use portability;              // constants for size of C data types

  export
    // Basic type declarations
    <function-declaration>, <structured-type-declaration>,
    <struct-declaration>, <union-declaration>, <variable-declaration>,
    <constant-declaration>, <typedef-declaration>, <pointer-declaration>,
    <vector-declaration>,

    // Preliminary "set declaration properties phase"
    ignored?-setter, find-result, find-parameter, find-slot,
    argument-direction-setter, constant-value-setter, getter-setter,
    setter-setter, read-only-setter, sealed-string-setter, excluded?-setter,
    exclude-slots, equate, remap, rename, superclasses-setter, pointer-equiv,
    dylan-name, exclude-decl,

    // "Import declarations phase" 
    declaration-closure, // also calls compute-closure

    // "Name computation phase"
    apply-options, apply-container-options, // also calls find-dylan-name,
					    // compute-dylan-name

    // "Write declaration phase"
    write-declaration, 
    write-file-load, write-mindy-includes,

    // Miscellaneous
    getter, setter, sealed-string, excluded?,
    canonical-name,declarations,
    melange-target;
end module c-declarations;
