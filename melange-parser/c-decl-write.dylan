documented: #t
module: c-declarations
copyright: see below
	   This code was produced by the Gwydion Project at Carnegie Mellon
	   University.  If you are interested in using this code, contact
	   "Scott.Fahlman@cs.cmu.edu" (Internet).

//======================================================================
//
// Copyright (c) 1995, 1996, 1997  Carnegie Mellon University
// Copyright (c) 1998 - 2004  Gwydion Dylan Maintainers
// All rights reserved.
// 
// Use and copying of this software and preparation of derivative
// works based on this software are permitted, including commercial
// use, provided that the following conditions are observed:
// 
// 1. This copyright notice must be retained in full on any copies
//    and on appropriate parts of any derivative works.
// 2. Documentation (paper or online) accompanying any system that
//    incorporates this software, or any part of it, must acknowledge
//    the contribution of the Gwydion Project at Carnegie Mellon
//    University, and the Gwydion Dylan Maintainers.
// 
// This software is made available "as is".  Neither the authors nor
// Carnegie Mellon University make any warranty about the software,
// its performance, or its conformity to any specification.
// 
// Bug reports should be sent to <gd-bugs@gwydiondylan.org>; questions,
// comments and suggestions are welcome at <gd-hackers@gwydiondylan.org>.
// Also, see http://www.gwydiondylan.org/ for updates and documentation. 
//
//======================================================================

//======================================================================
//
// Copyright (c) 1994  Carnegie Mellon University
// Copyright (c) 1998, 1999, 2000  Gwydion Dylan Maintainers
// All rights reserved.
//
//======================================================================

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

define method all-written-names( record :: <written-name-record> )
=> ( names :: <collection> )
	key-sequence( record.written-name-table );
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

//------------------------------------------------------------------------
// Methods definitions for exported functions
//------------------------------------------------------------------------

// For structures, we must define the basic class, write accessors for each of
// the slots, write an "identity" accessor function, and specify the size of
// the structure.
//

define variable *inhibit-struct-accessors?* = #f;

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
        & decl.simple-name ~= decl.type.simple-name)
    format(stream, "define constant %s = %s;\n\n",
	   decl.dylan-name, decl.type.dylan-name);
    register-written-name(back-end.written-names, decl.dylan-name, decl);
  end if;
end method write-declaration;
