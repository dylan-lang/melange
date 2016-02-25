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

define method mindy-mapped-name (decl :: <declaration>, #key explicit-only? :: <boolean> = #f) => (result :: false-or(<string>));
  let actual-type = decl.map-type | (~explicit-only? & decl.type);
  if (instance?(actual-type, <integer-type-declaration>))
    "<integer>";
  else
    mapped-name(decl, explicit-only?: explicit-only?);
  end if;
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

define method write-declaration
    (decl :: <function-declaration>, back-end :: <mindy-back-end>)
 => ();
  local method split-parameters (decl :: <function-type-declaration>)
          => (all-params :: <sequence>, in-params :: <sequence>, out-params :: <sequence>);
          let params = as(<list>, decl.parameters);
          let in-params
            = choose(method (p)
                       (p.direction == #"default" | p.direction == #"in"
                          | p.direction == #"in-out");
                     end method, params);
          let out-params
            = choose(method (p) p.direction == #"in-out" | p.direction == #"out" end,
                     params);
          if (decl.result.type ~= void-type)
            values(params, in-params, pair(decl.result, out-params));
          else
            values(params, in-params, out-params);
          end if;
        end method split-parameters;
  
  let stream = back-end.stream;
  let raw-name = anonymous-name();
  let (params, in-params, out-params) = split-parameters(decl.type);

  // First get the raw c function ...
  if (decl.type.result.type == void-type)
    format(stream, "define constant %s = find-c-function(\"%s\");\n",
           raw-name, decl.simple-name)
  else
    format(stream,
           "define constant %s\n  = constrain-c-function("
             "find-c-function(\"%s\"), #(), #t, list(%s));\n",
           raw-name, decl.simple-name,
           decl.type.result.mindy-mapped-name);
  end if;

  // ... then create a more robust method as a wrapper.
  format(stream, "define function %s\n    (", decl.dylan-name);
  register-written-name(back-end.written-names, decl.dylan-name, decl);
  for (arg in in-params, count from 1)
    if (count > 1) write(stream, ", ") end if;
    case
      instance?(arg, <varargs-declaration>) =>
	format(stream, "#rest %s", arg.dylan-name);
      otherwise =>
	format(stream, "%s :: %s", arg.dylan-name, arg.mindy-mapped-name);
    end case;
  end for;
  format(stream, ")\n => (");
  for (arg in out-params, count from 1)
    if (count > 1) write(stream, ", ") end if;
    format(stream, "%s :: %s", arg.dylan-name, arg.mindy-mapped-name);
  end for;
  format(stream, ");\n");

  for (arg in out-params)
    // Don't create a new variable if the existing variable is already the
    // right sort of pointer.
    if (instance?(arg, <arg-declaration>)
	  & (arg.direction == #"out"
	       | arg.type.dylan-name ~= arg.original-type.dylan-name))
      format(stream, "  let %s-ptr = make(%s);\n",
	     arg.dylan-name, arg.original-type.type-name);
      if (arg.direction == #"in-out")
	format(stream, "  %s-ptr.pointer-value := %s;\n",
	       arg.dylan-name, export-value(arg, arg.dylan-name));
      end if;
    end if;
  end for;

  let result-type = decl.type.result.type;
  if (result-type ~= void-type)
    format(stream, "  let result-value\n    = ");
  else
    write(stream, "  ");
  end if;

  begin
    if (~params.empty? & instance?(last(params), <varargs-declaration>))
      format(stream, "apply(%s, ", raw-name);
    else
      format(stream, "%s(", raw-name);
    end if;
    for (count from 1, arg in params)
      if (count > 1) write(stream, ", ") end if;
      if (instance?(arg, <varargs-declaration>))
        write(stream, arg.dylan-name);
      elseif (arg.direction == #"in-out" | arg.direction == #"out")
        format(stream, "%s-ptr", arg.dylan-name);
      else
        write(stream, export-value(arg, arg.dylan-name));
      end if;
    end for;
    format(stream, ");\n");
  end;

  for (arg in out-params)
    if (instance?(arg, <arg-declaration>))
      format(stream, "  let %s-value = %s;\n",
	     arg.dylan-name,
	     import-value(arg, format-to-string("pointer-value(%s-ptr)",
						arg.dylan-name)));
      if (arg.type.dylan-name ~= arg.original-type.dylan-name)
	format(stream, "destroy(%s-ptr);\n", arg.dylan-name);
      end if;
    end if;
  end for;

  write(stream, "  values(");
  for (arg in out-params, count from 1)
    if (count > 1) write(stream, ", ") end if;
    if (instance?(arg, <arg-declaration>))
      format(stream, "%s-value", arg.dylan-name);
    else
      write(stream, import-value(arg, "result-value"));
    end if;
  end for;

  format(stream, ");\nend function %s;\n\n", decl.dylan-name);
end method write-declaration;

//// Helpers

// import-value returns a string which contains dylan code for making a Dylan
// value out of the raw value in variable "var".  This will either be a call
// to the appropriate mapping function for the type named in "decl" or (if no
// mapping is defined) can just be the raw variable
//
define method import-value (decl :: <declaration>, var :: <string>)
 => (result :: <string>);
  if (mindy-mapped-name(decl, explicit-only?: #t))
    format-to-string("import-value(%s, %s)", decl.mindy-mapped-name, var);
  else
    var;
  end if;
end method import-value;

// See import-value above.  This method does the equivalent for converting
// Dylan values into raw "C" values.
//
define method export-value (decl :: <declaration>, var :: <string>)
 => (result :: <string>);
  if (mindy-mapped-name(decl, explicit-only?: #t))
    format-to-string("export-value(%s, %s)", decl.type-name, var);
  else
    var;
  end if;
end method export-value;
