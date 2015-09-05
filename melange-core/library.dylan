module: dylan-user
copyright: See LICENSE file in this distribution.
           This code was produced by the Gwydion Project at Carnegie Mellon
           University.  If you are interested in using this code, contact
           "Scott.Fahlman@cs.cmu.edu" (Internet).

define library melange-core
  use dylan;
  use common-dylan;
  use collection-extensions;
  use regular-expressions;
  use strings;
  use system;
  use io;

  // General purpose utility modules.
  export
    source-locations,
    parse-conditions,
    multistring-match;

  // Melange-specific.
  export
    c-lexer,
    c-declarations,
    portability;
end library melange-core;

define module source-locations
  use common-dylan, exclude: { format-to-string };
  use streams;
  use format;
  use standard-io;
  export
    source-location,
    <source-location>,
    describe-source-location,
    <unknown-source-location>,
    <file-source-location>,
      source-file,
      source-line;
end module source-locations;

define module parse-conditions
  use common-dylan, exclude: { format-to-string };
  use source-locations;
  use streams;
  use format;
  use standard-io;
  export
    *show-parse-progress-level*,
    $parse-progress-level-none,
    $parse-progress-level-headers,
    $parse-progress-level-all,
    <parse-condition>,
    <simple-parse-error>,
    <simple-parse-warning>,
    <parse-progress-report>,
    push-default-parse-context,
    pop-default-parse-context,
    // \with-default-parse-context,
    parse-error,
    parse-warning,
    parse-progress-report,
    parse-header-progress-report;
end module;

define module multistring-match
  use common-dylan;
  export
    multistring-checker-definer, multistring-positioner-definer,
    make-multistring-positioner, make-multistring-checker
end module multistring-match;

define module c-lexer
  use common-dylan,
    exclude: { format, format-to-string,
               split, position };
  use format;
  use self-organizing-list;
  use regular-expressions;
  use streams;
  use file-system;
  use locators;
  use source-locations;
  use parse-conditions,
    // XXX - These should probably go away.
    export: {parse-error,
             parse-warning,
             parse-progress-report};
  use strings;
  use %strings,
    import: { make-substring-positioner };
  use multistring-match;
  create cpp-parse;
  export
    *framework-paths*, find-frameworks,
    <tokenizer>, cpp-table, cpp-decls, <token>, token-id, generator,
    <simple-token>, <reserved-word-token>, <punctuation-token>,
    <literal-token>, <ei-token>, <name-token>, <type-specifier-token>,
    <identifier-token>, <integer-literal-token>, <character-literal-token>,
    <struct-token>, <short-token>, <long-token>, <int-token>, <char-token>,
    <signed-token>, <unsigned-token>, <float-token>, <double-token>,
    <void-token>, <bool-token>, <union-token>, <enum-token>, <minus-token>,
    <tilde-token>, <bang-token>, <alien-name-token>, <macro-parse-token>,
    <cpp-parse-token>, string-value, value, unget-token, add-typedef,
    get-token, include-path, check-cpp-expansion, file-in-include-path
end module c-lexer;

define module portability
  use dylan;
  use c-lexer, import: {include-path, *framework-paths*};
  use operating-system, import: {with-application-output, environment-variable};  // win32 only
  use common-extensions;
  use streams;
  use strings;
  export
    $default-defines,
    $default-undefines,
    $enum-size,
    $pointer-size, $function-pointer-size,
    $integer-size, $short-int-size,
    $long-int-size, $char-size,
    $longlong-int-size,
    $float-size, $double-float-size,
    $long-double-size;
end module portability;

define module c-parse
  use common-dylan, exclude: { format-to-string };
  use self-organizing-list;
  use c-lexer;
  use streams;
  use format;
  use standard-io;
  create
    <parse-state>, <parse-file-state>, <parse-value-state>,
    <parse-type-state>, <parse-cpp-state>,
    <parse-macro-state>, tokenizer, verbose, verbose-setter,
    push-include-level, pop-include-level, objects, process-type-list,
    process-declarator, declare-objects, make-struct-type, c-type-size,
    add-cpp-declaration, unknown-type, <declaration>, <arg-declaration>,
    <varargs-declaration>, <enum-slot-declaration>, constant-value,
    <integer-type-declaration>,
    <signed-integer-type-declaration>,
    <unsigned-integer-type-declaration>,
    canonical-name, true-type, type-size-slot, make-enum-slot,
    referent;
  export
    parse, parse-type, parse-macro;
end module c-parse;

define module c-declarations
  use common-dylan, exclude: { format-to-string, split };
  use dylan-extensions;
  use regular-expressions;
  use streams;
  use file-system;
  use format;
  use standard-io;
  use pprint;

  // We completely encapsulate "c-parse" and only pass out the very few
  // objects that will be needed by "define-interface".  Note that the
  // classes are actually defined within this module but are exported
  // from c-parse.
  use c-parse, export: {<declaration>, <parse-state>, parse, parse-type,
                        constant-value, true-type, canonical-name, referent};

  use c-lexer;                        // Tokens are used in process-type-list and
                                // make-struct-type
  use portability;              // constants for size of C data types
  use source-locations;         // Used for error and
  use parse-conditions;         //   progress reporting.

  export
    // Basic type declarations
    <function-declaration>, <structured-type-declaration>,
    <struct-declaration>, <union-declaration>, <variable-declaration>,
    <constant-declaration>, <typedef-declaration>, <pointer-declaration>,
    <vector-declaration>, <function-type-declaration>,
    local-name-mapper, local-name-mapper-setter,
    callback-maker-name, callback-maker-name-setter,
    callout-function-name, callout-function-name-setter,

    // Preliminary "set declaration properties phase"
    ignored?-setter, find-result, find-parameter, find-slot,
    argument-direction-setter, constant-value-setter, getter-setter,
    setter-setter, read-only-setter, sealed-string-setter, inlined-string-setter,
    excluded?-setter, exclude-slots, equate, remap, rename, superclasses-setter,
    pointer-equiv, dylan-name, exclude-decl,

    // "Import declarations phase"
    declaration-closure, // also calls compute-closure

    // "Name computation phase"
    apply-options, apply-container-options, // also calls find-dylan-name,
                                            // compute-dylan-name

    // "Write declaration phase"
    <written-name-record>,
                all-written-names,
    write-declaration,

    // Miscellaneous
    getter, setter, sealed-string, inlined-string, excluded?,
    error-result?, error-result?-setter, declarations,
    make-backend-for-target, written-names;
end module c-declarations;
