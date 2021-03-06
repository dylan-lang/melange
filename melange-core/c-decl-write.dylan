module: c-declarations
copyright: See LICENSE file in this distribution.
           This code was produced by the Gwydion Project at Carnegie Mellon
           University.  If you are interested in using this code, contact
           "Scott.Fahlman@cs.cmu.edu" (Internet).

//======================================================================
// "C-decl-write.dylan" contains code to write out Dylan code corresponding to
// various c declarations.  This will likeley be replaced in later versions by
// code which simply builds a parse tree or produces native code.  The current
// version has the advantage of being highly portable -- the Dylan code it
// writes depends upon a relatively small set of primitives defined in module
// "extern".
//======================================================================

//------------------------------------------------------------------------
// Exported variables
//------------------------------------------------------------------------

define abstract class <back-end> (<object>)
  constant slot stream :: <stream>, required-init-keyword: stream:;
  constant slot written-names :: <written-name-record> = make(<written-name-record>);
end;

//------------------------------------------------------------------------
// Exported function declarations.
//------------------------------------------------------------------------

// Writes out all the Dylan code corresponding to one <declaration>.  The
// exact behavior can, of course, vary widely depending on the variety of
// declaration.
//
// Most of the code in this file goes to support this single operation.
//
define generic write-declaration
    (decl :: <declaration>, back-end :: <back-end>) => ();


//------------------------------------------------------------------------
//  <written-name-record> -- maintains a set of all names written so far,
//  and detects duplicate names.
//------------------------------------------------------------------------

define class <written-name-record> (<object>)
  constant slot written-name-table :: <table> /* <symbol> => <declaration> */
    = make(<table>);
end class <written-name-record>;

define method all-written-names (record :: <written-name-record>)
=> (names :: <collection>)
  key-sequence(record.written-name-table);
end method all-written-names;

define class <written-declaration> (<object>)
  constant slot written-declaration :: <declaration>,
    required-init-keyword: declaration:;
  constant slot written-name :: <string>,
    required-init-keyword: name:;
end class <written-declaration>;

define function register-written-name
    (rec :: <written-name-record>, name :: <string>,
     decl :: <declaration>, #key subname? = #f)
 => (duplicate? :: <boolean>);

  let interned-name = as(<symbol>, name);
  let table = rec.written-name-table;
  let existing = element(table, interned-name, default: #f);

  // If there is already a symbol by that name, there is a potential
  // conflict if the case is different, or if either of the names is
  // not a structure accessor.  If both are struct slot accessors then
  // it's probably okay.
  if (existing
        & (name ~= existing.written-name
             | ~instance?(decl, <structured-type-declaration>)
             | ~instance?(existing.written-declaration,
                          <structured-type-declaration>)))
    // XXX - We should try to extract a source location from each record
    // when printing these error messages. We should also give the C and
    // Dylan forms of each name. But doing so will be a pain.
    signal(make(<simple-warning>,
                format-string: "melange: %s has multiple definitions",
                format-arguments: list(name)));
    #t;
  else
    element(table, interned-name)
      := make(<written-declaration>, declaration: decl, name: name);
    #f;
  end if;
end function register-written-name;


//------------------------------------------------------------------------
// Support code
//------------------------------------------------------------------------

// Private variable used (and modified) by anonymous-name.
define variable anonymous-count :: <integer> = 0;

// Generates a new name for a function or type.  We don't actually check that
// the user hasn't generated an identical name, but rely instead upon the
// relative obscurity of a variable named "anonymous-???".
//
define method anonymous-name () => (name :: <string>);
  let name = format-to-string("anonymous-%d", anonymous-count);
  anonymous-count := anonymous-count + 1;
  name;
end method anonymous-name;

define method escape-characters (s :: <string>) => (s* :: <string>)
  let new = make(<stretchy-vector>);

  for (char in s)
    select (char)
      '\\'      => do(curry(add!, new), "\\\\");
      '"'       => do(curry(add!, new), "\\\"");
      '\n'      => do(curry(add!, new), "\\n\"\n\"");
      '\r'      => do(curry(add!, new), "\\r");
      otherwise => add!(new, char);
    end select;
  end for;
  as(<string>, new);
end method escape-characters;

//------------------------------------------------------------------------
// Methods definitions for exported functions
//------------------------------------------------------------------------

// For structures, we must define the basic class, write accessors for each of
// the slots, write an "identity" accessor function, and specify the size of
// the structure.
//

// Typedefs are just aliases.  Define a constant which is initialized to the
// original type.  Because "typedef struct foo foo" is such a common case and
// would lead to conflicts, we check for it specially and ignore the typedef
// if it occurs.
//
define method write-declaration
    (decl :: <typedef-declaration>, back-end :: <back-end>)
 => ();
  let stream = back-end.stream;
  // We must special case this one since there are so many declarations of the
  // form "typedef struct foo foo".
  if (~decl.equated?
        & ~string-equal-ic?(decl.simple-name, decl.type.simple-name))
    format(stream, "define constant %s = %s;\n\n",
           decl.dylan-name, decl.type.dylan-name);
    register-written-name(back-end.written-names, decl.dylan-name, decl);
  end if;
end method write-declaration;
