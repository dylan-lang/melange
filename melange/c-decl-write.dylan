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

define class <c-ffi-back-end> (<back-end>)
end;

define method make-backend-for-target (target == #"c-ffi", stream :: <stream>)
  make(<c-ffi-back-end>, stream: stream)
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
  slot written-name-table :: <table> /* <symbol> => <declaration> */
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

// C accessor returns a string with the appropriate Dylan code for
// "dereferencing" the named parameter, assuming that the result of the
// operation will have the characteristics of "type".  "Equated" specifies the
// name of the actual type for non-static (i.e. pointer) values which have
// been "equate:"ed, or #f otherwise.
//
// The offset (which may be an integer or a string which contains an
// integral Dylan expression) ends up being added to the address.  This is
// useful for accessing a slot of a larger structure.
//
define generic c-accessor
    (type :: <type-declaration>, offset :: type-union(<integer>, <string>),
     parameter :: <string>, equated :: <string>)
 => (result :: <string>);

// import-value returns a string which contains dylan code for making a Dylan
// value out of the raw value in variable "var".  This will either be a call
// to the appropriate mapping function for the type named in "decl" or (if no
// mapping is defined) can just be the raw variable
//
define method import-value (decl :: <declaration>, var :: <string>)
 => (result :: <string>);
  if (mapped-name(decl, explicit-only?: #t))
    format-to-string("import-value(%s, %s)", decl.mapped-name, var);
  else
    var;
  end if;
end method import-value;

// See import-value above.  This method does the equivalent for converting
// Dylan values into raw "C" values.
//
define method export-value (decl :: <declaration>, var :: <string>)
 => (result :: <string>);
  if (mapped-name(decl, explicit-only?: #t))
    format-to-string("export-value(%s, %s)", decl.type-name, var);
  else
    var;
  end if;
end method export-value;

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

// catch-all method, returning just a comment
//
define method c-accessor
    (type :: <type-declaration>,  offset :: type-union(<integer>, <string>),
     parameter :: <string>, equated :: <string>)
 => (result :: <string>);
  format-to-string("/* FIXME: no c-accessor defined for %=, named %=. */",
                   type, type.type-name);
end method c-accessor;

// This method simply converts integral parameters into strings for later
// processing by other methods.
//
define method c-accessor
    (type :: <type-declaration>, offset :: <integer>, parameter :: <string>,
     equated :: <string>)
 => (result :: <string>);
  c-accessor(type, format-to-string("%d", offset), parameter, equated);
end method c-accessor;

define method c-accessor
    (type :: <integer-type-declaration>, offset :: <string>,
     parameter :: <string>, equated :: <string>)
 => (result :: <string>);
  // Each builtin integer type specifies its own accessor function.  We can
  // safely ignore "equated".
  format-to-string("%s(%s, offset: %s)",
		   type.accessor-name, parameter, offset);
end method c-accessor;

define method c-accessor
    (type :: <float-type-declaration>, offset :: <string>,
     parameter :: <string>, equated :: <string>)
 => (result :: <string>);
  format-to-string("%s(%s, offset: %s)",
		   type.accessor-name, parameter, offset);
end method c-accessor;

define method c-accessor
    (type :: <enum-declaration>, offset :: <string>,
     parameter :: <string>, equated :: <string>)
 => (result :: <string>);
  format-to-string("unsigned-long-at(%s, offset: %s)",
		   parameter, offset);
end method c-accessor;

define method c-accessor
    (type :: type-union(<pointer-declaration>, <function-type-declaration>),
     offset :: <string>, parameter :: <string>,
     equated :: <string>)
 => (result :: <string>);
  format-to-string("pointer-at(%s, offset: %s, class: %s)",
		   parameter, offset, equated);
end method c-accessor;

define constant <non-atomic-types>
    = type-union(<struct-declaration>, <union-declaration>,
		 <vector-declaration>, <function-type-declaration>);
define constant <pointer-rep-types>
    = type-union(<pointer-declaration>, <non-atomic-types>);

define method c-accessor
    (type :: <non-atomic-types>,
     offset :: <string>, parameter :: <string>, equated :: <string>)
 => (result :: <string>);
  // This one is non-intuitive.  When you "dereference" a pointer or a slot
  // whose contents are a "structure" or "vector" (as distinct from a
  // pointer), you just get a pointer to it, since the actual "contents" can't
  // be expressed.  You can, of course, get a portion of the "contents" by
  // accessing a slot or element.
  //
  // Note that the only way you should get a "vector" is as a structure slot.
  // If we had a declaration like "(*)(foo [])" (i.e. a "pointer" to a
  // "vector") then this routine could produce bad results.  However, this
  // sort of declaration is either impossible or very uncommon.
  format-to-string("as(%s, %s + %s)", equated, parameter, offset);
end method c-accessor;

define method c-accessor
    (alias :: <typedef-declaration>, offset :: <string>, parameter :: <string>,
     equated :: <string>)
 => (result :: <string>);
  // Push past an alias to get the real accessor.
  c-accessor(alias.type, offset, parameter, equated);
end method c-accessor;

// This method writes out accessors for a single slot.  All non-excluded slots
// get "getter" methods, but there may not be a setter method if the slot is
// declared "read-only" or if the value is something unsettable like a
// struct or vector.  (Note that you can set *pointers* to structs or pointers
// to "vectors" -- the check only applies to inline structs, unions, and
// vectors.) 
//
define method write-c-accessor-method
    (compound-type :: <type-declaration>,
     slot-type :: <slot-declaration>, offset :: <integer>,
     written-names :: <written-name-record>, stream :: <stream>)
 => ();
  let real-type = true-type(slot-type.type);
  let slot-name = slot-type.dylan-name;
  // Write getter method
  unless(real-type.abstract-type?)
    format(stream,
           "define %s inline method %s\n"
             "    (ptr :: %s) => (result :: %s);\n"
             "  %s;\n"
             "end method %s;\n\n",
           slot-type.sealed-string, slot-name, compound-type.type-name,
           slot-type.mapped-name,
           import-value(slot-type, c-accessor(slot-type.type, offset,
                                              "ptr", slot-type.type-name)),
           slot-name);
    register-written-name(written-names, slot-name, compound-type);
    
    if (~slot-type.read-only
          & ~instance?(real-type, <non-atomic-types>))
      // Write setter method
      format(stream,
             "define %s inline method %s-setter\n"
               "    (value :: %s, ptr :: %s) => (result :: %s);\n"
               "  %s := %s;\n"
               "  value;\n"
               "end method %s-setter;\n\n",
             slot-type.sealed-string, slot-name, slot-type.mapped-name,
             compound-type.type-name, slot-type.mapped-name,
             c-accessor(slot-type.type, offset,
                        "ptr", slot-type.type-name),
             export-value(slot-type, "value"), slot-name);
      register-written-name(written-names, concatenate(slot-name, "-setter"),
                            compound-type);
    end if;
  end unless;
end method write-c-accessor-method;

// write-c-accessor-method -- internal
//
// This writes a series of accessor methods for the various bitfields
// which are stored in a single <coalesced-bitfields> pseudo-slot.  It
// is roughly parallel to "write-c-accessor-method" above, but care must
// be taken to distinguish between the "glob-type" which is the
// pseudo-slot holding some kind of integer, and "slot-type" which is
// the actual bitfield slot that must be extracted from that integer.
//
// No attempt has (yet) been made to optimize bitfield access.
//
define method write-c-accessor-method
    (compound-type :: <structured-type-declaration>, 
     glob-type :: <coalesced-bitfields>, offset :: <integer>,
     written-names :: <written-name-record>, stream :: <stream>)
 => ();
  for (slot-type in glob-type.fields)
    unless (slot-type.excluded?)
      let slot-name = slot-type.dylan-name;
      let real-type = true-type(slot-type.type);

      let extractor =
	format-to-string("logand(ash(%s, -%d), (2 ^ %d) - 1)",
			 c-accessor(glob-type.type, offset,
				    "ptr", compound-type.type-name),
			 real-type.start-bit, real-type.bits-in-field);
      // Write getter method
      format(stream,
	     "define %s inline method %s\n"
	       "    (ptr :: %s) => (result :: %s);\n"
	       "  %s;\n"
	       "end method %s;\n\n",
	     slot-type.sealed-string, slot-name, compound-type.type-name,
	     slot-type.mapped-name, import-value(slot-type, extractor),
	     slot-name);
      register-written-name(written-names, slot-name, compound-type);

      if (~slot-type.read-only
	    & ~instance?(real-type, <non-atomic-types>))
	// Write setter method
	format(stream,
	       "define %s inline method %s-setter\n"
		 "    (value :: %s, ptr :: %s) => (result :: %s);\n"
		 "  let mask = lognot(ash((2 ^ %d) - 1, %d));\n"
		 "  %s := logand(%s, mask) + ash(%s, %d);\n"
		 "  value;\n"
		 "end method %s-setter;\n\n",
	       // header
	       slot-type.sealed-string, slot-name, slot-type.mapped-name,
	       compound-type.type-name, slot-type.mapped-name,
	       // mask
	       real-type.bits-in-field, real-type.start-bit,
	       // setter
	       c-accessor(glob-type.type, offset,
			  "ptr", compound-type.type-name),
	       c-accessor(glob-type.type, offset,
			  "ptr", compound-type.type-name),
	       export-value(slot-type, "value"), real-type.start-bit,
	       // footer
	       slot-name);
	register-written-name(written-names, concatenate(slot-name, "-setter"),
			      compound-type);
      end if;
    end unless;
  end for;
end method write-c-accessor-method;

//------------------------------------------------------------------------
// Methods definitions for exported functions
//------------------------------------------------------------------------

// For structures, we must define the basic class, write accessors for each of
// the slots, write an "identity" accessor function, and specify the size of
// the structure.  "Write-c-accessor-method" will do all the real work of
// creating slot accessors.
//

define variable *inhibit-struct-accessors?* = #f;

define method write-declaration
    (decl :: <enum-slot-declaration>, back-end :: <back-end>)
 => ();
  // The routine for <enum-declaration> will already have written these, so we
  // need do nothing.
  #f;
end method write-declaration;


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

// Only "simple" macros will appear amongst the declarations, and even those
// are not guaranteed to be compile time values.  None-the-less, we run them
// through the parser and see if it can come up with either a single specific
// declaration (in which case we treat it as an alias) or with a compile time
// value, which we will declare as a constant.  In other words,
//   #define foo 3
// will yield
//   define constant $foo 3
// and 
//   #define bar "char *"
// might yield
//   define constant <bar> = <c-string>
// (but only if the user had equated "char *" to <c-string>).  Some other
// routine has the task of figuring out what sort of a declaration we are
// aliasing and compute the appropriate sort of name.
//
define method write-declaration
    (decl :: <macro-declaration>, back-end :: <back-end>)
 => ();
  let stream = back-end.stream;
  let raw-value = decl.constant-value;
  let value = select (raw-value by instance?)
		<declaration> => raw-value.dylan-name;
		<integer>, <float> => format-to-string("%=", raw-value);
		<string> => format-to-string("\"%s\"", 
                                             escape-characters(raw-value));
		<token> => raw-value.string-value;
		<character> => "1"; // for #define FOO\n, suggested by dauclair
	      end select;
  unless(decl.dylan-name = value)
    unless(register-written-name(back-end.written-names, decl.dylan-name, decl))
      format(stream, "define constant %s = %s;\n\n", decl.dylan-name, value);
    end unless;
  end unless;
end method write-declaration;

define method escape-characters(s :: <string>) => (s* :: <string>)
  let new = make(<stretchy-vector>);

  for(char in s)
    select(char)
      '\\'      => do(curry(add!, new), "\\\\");
      '"'       => do(curry(add!, new), "\\\"");
      '\n'      => do(curry(add!, new), "\\n\"\n\"");
      '\r'      => do(curry(add!, new), "\\r");
      otherwise => add!(new, char);
    end select;
  end for;
  as(<string>, new);
end method escape-characters;
