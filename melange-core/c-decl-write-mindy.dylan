module: c-declarations
copyright: See LICENSE file in this distribution.

define class <mindy-back-end> (<back-end>)
end;

define method make-backend-for-target (target == #"mindy", stream :: <stream>)
  make(<mindy-back-end>, stream: stream)
end;

define method write-declaration (decl :: <declaration>, back-end :: <mindy-back-end>)
 => ()
  format(back-end.stream, " /* Ignoring declaration for %= %=*/\n", decl, decl.dylan-name)
end;

// Enums are defined to be a limited subtype of <integer>, and constants
// values are written for each literal.
//
define method write-declaration
    (decl :: <enum-declaration>, back-end :: <mindy-back-end>)
 => ()
  if (~decl.equated?)
    let type-name = decl.dylan-name;

    // This may still be an "incomplete type".  If so, we just define the class
    // as a synonym for <integer>
    if (decl.members)
      if (any?(method (e) ~e.excluded? end, decl.members))
        let min-enum = reduce(method (a, b) min(a, b.constant-value) end method,
                              $maximum-integer, decl.members);
        let max-enum = reduce(method (a, b) max(a, b.constant-value) end method,
                              $minimum-integer, decl.members);
        format(back-end.stream,
               "define constant %s = limited(<integer>, min: %d, max: %d);\n",
               type-name, min-enum, max-enum);
        register-written-name(back-end.written-names, type-name, decl);
      end if;

      let wrote-some? = #f;
      for (literal in decl.members)
        if (~literal.excluded?)
          let name = literal.dylan-name;
          let int-value = literal.constant-value;
          format(back-end.stream, "define constant %s :: %s = %d;\n",
                 name, type-name, int-value);
          register-written-name(back-end.written-names, name, decl, subname?: #t);
          wrote-some? := #t;
        end if;
      finally
        if (wrote-some?)
          new-line(back-end.stream);
        end if;
      end for;
    else
      format(back-end.stream, "define constant %s = <integer>;\n\n",
             type-name);
      register-written-name(back-end.written-names, type-name, decl);
    end if;
  end if;
end method write-declaration;

define method write-declaration
    (decl :: <enum-slot-declaration>, back-end :: <mindy-back-end>)
 => ()
  // The routine for <enum-declaration> will already have written these, so we
  // need do nothing.
  #f;
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
    (decl :: <macro-declaration>, back-end :: <mindy-back-end>)
 => ();
  let stream = back-end.stream;
  let raw-value = decl.constant-value;
  let value = select (raw-value by instance?)
                <declaration> => raw-value.dylan-name;
                <integer> => integer-to-string(raw-value);
                <float> => float-to-string(raw-value);
                <string> => format-to-string("\"%s\"",
                                             escape-characters(raw-value));
                <float-literal-token> => raw-value.as-dylan-float;
                <token> => raw-value.string-value;
                <character> => format-to-string("'%c'", raw-value);
              end select;
  unless (decl.dylan-name = value)
    unless (register-written-name(back-end.written-names, decl.dylan-name, decl))
      format(stream, "define constant %s = %s;\n\n", decl.dylan-name, value);
    end unless;
  end unless;
end method write-declaration;
