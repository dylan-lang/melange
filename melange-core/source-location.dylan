module: source-locations
copyright: See LICENSE file in this distribution.

//======================================================================
//  Simplified source location library
//======================================================================
// A stripped-down version of gd/src/d2c/compiler/base/source.dylan.
//
// This library provides a minimalist version of d2c's <source-location>
// code. The only two available subclasses are <unknown-source-location>
// and a simplified version of <file-source-location>.


//======================================================================
//  Creating a <source-location> from an object
//======================================================================
//  Return the location in the source where the thing came from, or #f if
//  unknown.

define open generic source-location (thing :: <object>)
    => res :: <source-location>;


//======================================================================
//  Source location protocol
//======================================================================
//  Subclasses of <source-location> need to implement
//  describe-source-location, which should print out a brief description
//  of the location.

define open abstract class <source-location> (<object>)
end;

define sealed domain make (singleton(<source-location>));

define method make (wot == <source-location>, #key)
    => res :: <source-location>;
  make(<unknown-source-location>);
end;

define open generic describe-source-location
    (srcloc :: <source-location>, stream) => ();


//======================================================================
//  Unknown source locations
//======================================================================
//  There is only one instance of this class.

define class <unknown-source-location> (<source-location>)
end;

define sealed domain make (singleton(<unknown-source-location>));
define sealed domain initialize (<unknown-source-location>);

define variable *unknown-srcloc* :: false-or(<unknown-source-location>) = #f;

define method make
    (class == <unknown-source-location>, #next next-method, #key)
    => res :: <unknown-source-location>;
  *unknown-srcloc* | (*unknown-srcloc* := next-method());
end method make;

define sealed method describe-source-location
    (srcloc :: <unknown-source-location>, stream)
    => ();
  format(stream, "(unknown source location): ");
end method describe-source-location;


//======================================================================
//  File source locations
//======================================================================
//  This is much simpler than d2c's equivalent class, and not entirely
//  compatible.

define class <file-source-location> (<source-location>)
  constant slot source-file :: <string>,
    required-init-keyword: file:;

  constant slot source-line :: <integer>,
    required-init-keyword: line:;

  constant slot source-line-position :: false-or(<integer>),
    init-keyword: line-position:,
    init-value: #f;
end;

ignore(source-line-position);

define sealed domain make (singleton(<file-source-location>));
define sealed domain initialize (<file-source-location>);

define sealed method describe-source-location
    (srcloc :: <file-source-location>, stream)
    => ();
//  if (srcloc.source-line-position)
//      condition-format(stream, "%s:%d:%d: ",
//                     srcloc.source-file,
//                     srcloc.source-line,
//                     srcloc.source-line-position);
//  else
  format(stream, "%s:%d: ", srcloc.source-file, srcloc.source-line);
//  end if;
end method describe-source-location;
