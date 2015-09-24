module: dylan-user
copyright: See LICENSE file in this distribution.
           This code was produced by the Gwydion Project at Carnegie Mellon
           University.  If you are interested in using this code, contact
           "Scott.Fahlman@cs.cmu.edu" (Internet).

//======================================================================
// Library "melange" contains the complete functionality (except possibly for
// user extensions to name mappers) of the Melange interface generator (Mindy
// version).  Since it is intended as a stand-alone program, there is no need
// to export most of its functionality.  "Name-mappers" is exported to
// facilitate user extension of the program.  See "name-map.dylan" or the
// Melange documentation for further instructions on such extension.
//======================================================================
// Melange versions:
//   b1.0: (04/28/95)
//     Initial "beta" release
//   b1.1: (05/17/95)
//     Added "superclasses" option for structure and union clauses
//     Bug fixes:
//       Allow enumeration literals in compile time expressions (including
//         specification of other literal values)
//       Show token string rather than token type in error messages
//       Report line numbers rather than character numbers in error messages
//       Report name of interface files in error messages
//       Fix handling of empty strings in interfaces
//       Fix handling of CPP '#include "foo"'
//       Allow CPP '#pragma'
//       Fix handling of CPP foo##bar
//   b1.2: (10/25/95)
//     Improved portability handling:
//       portable size constants
//       multiple alignment models
//     Improved vector handling:
//       vector operations now only apply to subclasses of <c-vector>
//       added "pointer" clause to interface declaration.
//       <c-strings> now have more correct (and documented) behavior
//     Bug fixes:
//       Fixed various routines to work if "members" is #f.
//       Fixed handling of equated typedefs.
//       Fixed bug in explit-ony? keyword for mapped-name.
//       Fixed handling of types which are mapped to themselves.
//======================================================================

define library melange
  use common-dylan;
  use collection-extensions;
  use io;
  use system;
  use command-line-parser;
  use strings;
  use regular-expressions;
  use melange-core;
  export
    name-mappers;
end library melange;

define module int-lexer
  use common-dylan,
    exclude: { format-to-string, position, split };
  use self-organizing-list;
  use streams;
  use strings;
  use regular-expressions;
  export
    <tokenizer>, get-token, unget-token, <token>, value, string-value,
    generator, parse-error, position, token-id,
    <reserved-word-token>, <name-token>, <punctuation-token>,
    <error-token>, <identifier-token>, <simple-token>,
    <integer-token>, <eof-token>, <keyword-token>,
    <symbol-literal-token>, <string-literal-token>, <comma-token>,
    <semicolon-token>, <lbrace-token>, <rbrace-token>, <arrow-token>,
    <define-token>, <interface-token>, <end-token>, <include-token>,
    <define-macro-token>, <undefine-token>,
    <name-mapper-token>, <import-token>, <prefix-token>, <exclude-token>,
    <exclude-file-token>, <rename-token>, <mapping-token>, <equate-token>,
    <superclass-token>, <all-token>, <all-recursive-token>, <none-token>,
    <function-token>, <map-result-token>, <equate-result-token>, <map-error-result-token>,
    <ignore-result-token>, <map-argument-token>, <equate-argument-token>,
    <input-argument-token>, <output-argument-token>,
    <input-output-argument-token>, <struct-token>, <union-token>,
    <pointer-token>, <constant-token>, <variable-token>, <getter-token>,
    <setter-token>, <read-only-token>, <seal-token>, <seal-functions-token>,
    <boolean-token>, <sealed-token>, <open-token>, <inline-token>,
    <value-token>, <function-type-token>, <literal-token>,
    <pointer-type-name-token>;
end module int-lexer;

define module int-parse
  use common-dylan, exclude: { format-to-string, position };
  use self-organizing-list;
  use c-lexer, import: {include-path, file-in-include-path};
  use streams;
  use standard-io;
  use format;
  use int-lexer;
  export
    parse, <parse-state>, include-files,
    container-options, macro-defines, macro-undefines, clauses,
    <container-options>, name-mapper, global-imports, global-import-mode,
    file-imports, file-import-modes, prefix, exclude, excluded-files, rename,
    mappings, equates, read-only, seal-string, inline-string, <clause>,
    <function-clause>, <struct-clause>, <union-clause>, <pointer-clause>,
    <constant-clause>, <variable-clause>, <function-type-clause>, name,
    options, <undefined>, undefined, pointer-type-name;
end module int-parse;

define module name-mappers
  use dylan;
  use strings;
  export
    map-name, hyphenate-case-breaks;
end module name-mappers;

define module define-interface
  // From Dylan
  use common-dylan, exclude: { format-to-string, split, position };

  // From io
  use streams;

  // From io
  use format;

  // From io
  use standard-io;

  // From strings
  use strings;
  use %strings,
    import: { make-substring-positioner };

  // From system
  use file-system;

  // From command-line-parser
  use command-line-parser;

  // local packages
  use int-lexer;
  use int-parse, rename: {rename => renames};
  use c-lexer, import: {include-path, file-in-include-path, *framework-paths*, find-frameworks};
  use c-declarations,
    rename: {parse => c-parse, <parse-state> => <c-parse-state>};
  use name-mappers;
  use portability;
  use parse-conditions, exclude: {parse-error};
end module define-interface;

