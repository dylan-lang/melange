module: c-declarations
copyright: See LICENSE file in this distribution.

define class <c-ffi-back-end> (<back-end>)
end;

define method make-backend-for-target (target == #"c-ffi", stream :: <stream>)
  make(<c-ffi-back-end>, stream: stream)
end;

define method write-declaration (decl :: <declaration>, back-end :: <c-ffi-back-end>)
 => ();
  format(back-end.stream, " /* Ignoring declaration for %= %=*/\n", decl, decl.dylan-name)
end;

define method write-declaration (decl :: <struct-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  register-written-name(back-end.written-names, decl.dylan-name, decl);
  if (decl.superclasses)
    format(back-end.stream, "define C-subtype %s (%s) end;\n",
           decl.dylan-name, join(decl.superclasses, ", "));
  else
    let stream = back-end.stream;
    format(stream, "define C-struct %s\n", decl.dylan-name);

    decl.members
      & do(method(slot)
             let adjectives
               = concatenate(if (slot.read-only) "constant " else "" end,
                             slot.sealed-string,
                             if (~empty?(slot.sealed-string)) " " else "" end);
             if (instance?(slot.type, <bitfield-declaration>))
               format(stream, "  %sbitfield slot %s :: %s, width: %d;\n",
                      adjectives, slot.dylan-name, slot.type.true-type.type-name, slot.type.bits-in-field)
             elseif (instance?(slot.type, <vector-declaration>))
               format(stream, "  %sarray slot %s :: %s, length: %d;\n",
                      adjectives, slot.dylan-name, slot.type.pointer-equiv.referent.type-name, slot.type.length)
             else
               format(stream, "  %sslot %s :: %s;\n",
                      adjectives, slot.dylan-name, slot.type.true-type.type-name)
             end;
             register-written-name(back-end.written-names, slot.dylan-name, decl);
             register-written-name(back-end.written-names,
                                   concatenate(slot.dylan-name, "-setter"), decl);
           end, decl.members);
    if (decl.pointer-type-name)
      let name = as(<string>, decl.pointer-type-name);
      format(stream, "  pointer-type-name: %s;\n", name);
      register-written-name(back-end.written-names, name, decl);
    end if;
    format(stream, "end;\n\n");
  end;
end;

define method write-declaration
    (decl :: <typedef-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  let stream = back-end.stream;
  // We must special case this one since there are so many declarations of the
  // form "typedef struct foo foo".
  if (~decl.equated?
        & (decl.simple-name ~= decl.type.simple-name))
    if (instance?(decl.type, <struct-declaration>)
        & decl.type.superclasses
        & (copy-sequence(decl.dylan-name, start: 1) ~= copy-sequence(decl.type.dylan-name, start: 2)))
      let underscore-name = concatenate("<", copy-sequence(decl.dylan-name));
      underscore-name[1] := '_';
      format(stream, "define C-subtype %s (%s) end;\n\n",
             underscore-name, decl.type.dylan-name);
      register-written-name(back-end.written-names, decl.dylan-name, decl);
      register-written-name(back-end.written-names, underscore-name, decl);
      format(stream, "define constant %s = %s;\n\n",
             decl.dylan-name, underscore-name);
    else
      format(stream, "define constant %s = %s;\n\n",
             decl.dylan-name, decl.type.dylan-name);
    end;
    register-written-name(back-end.written-names, decl.dylan-name, decl);
  end if;
end method write-declaration;

define method write-declaration (decl :: <union-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  register-written-name(back-end.written-names, decl.dylan-name, decl);
  if (decl.superclasses)
    format(back-end.stream, "define C-subtype %s (%s) end;\n",
           decl.dylan-name, join(decl.superclasses, ", "));
  else
    let stream = back-end.stream;
    format(stream, "define C-union %s\n", decl.dylan-name);

    decl.members
      & do(method(slot)
             if (instance?(slot.type, <vector-declaration>))
               format(stream, "  array slot %s :: %s, length: %d;\n",
                      slot.dylan-name, slot.type.pointer-equiv.referent.type-name, slot.type.length)
             else
               format(stream, "  slot %s :: %s;\n",
                      slot.dylan-name, slot.type.true-type.type-name)
             end;
             register-written-name(back-end.written-names, slot.dylan-name, decl);
             register-written-name(back-end.written-names,
                                   concatenate(slot.dylan-name, "-setter"), decl);
           end, decl.members);
    if (decl.pointer-type-name)
      let name = as(<string>, decl.pointer-type-name);
      format(stream, "  pointer-type-name: %s;\n", name);
      register-written-name(back-end.written-names, name, decl);
    end if;
    format(stream, "end;\n\n");
  end;
end;

define method write-declaration (decl :: <pointer-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  unless (decl.dylan-name = decl.referent.dylan-name)
    register-written-name(back-end.written-names, decl.dylan-name, decl);

    let stream = back-end.stream;

    if (decl.superclasses)
      let dylan-temp-name = concatenate("<_", decl.simple-name, ">");
      format(stream, "define C-pointer-type %s => %s;\n", dylan-temp-name, decl.referent.dylan-name);

      let supers = remove!(decl.superclasses, "<statically-typed-pointer>", test: \=);
      supers := add!(supers, dylan-temp-name);
      format(stream, "define C-subtype %s (%s) end;\n\n",
             decl.dylan-name, join(supers, ", "));

    else
      format(stream, "define C-pointer-type %s => %s;\n",
             decl.dylan-name, decl.referent.dylan-name);
    end if;
  end;
end;

define method write-declaration (decl :: <function-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  let stream = back-end.stream;
  register-written-name(back-end.written-names, decl.dylan-name, decl);

  format(stream, "define %s%sC-function %s\n", decl.inlined-string,
         if (~empty?(decl.inlined-string)) " " else "" end, decl.dylan-name);
  for (param in decl.type.parameters)
    unless (instance?(param, <varargs-declaration>))
      format(stream, "  %s parameter %s_ :: %s;\n",
             select (param.direction)
               #"default", #"in" => "input";
               #"out" => "output";
               #"in-out" => "input output";
             end,
             param.dylan-name, param.mapped-name)
    end;
  end;
  let result = decl.type.result;
  if (result.type ~= void-type)
    if (~result.error-result?)
      format(stream, "  result res :: %s;\n", result.mapped-name);
    else
      format(stream, "  error-result res :: %s;\n", result.mapped-name);
    end if;
  end;
  format(stream, "  c-name: \"%s\";\n", decl.simple-name);
  format(stream, "end;\n\n");
end;

define method write-declaration (decl :: <function-type-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  let stream = back-end.stream;
  register-written-name(back-end.written-names, decl.dylan-name, decl);

  format(stream, "define constant %s = <C-function-pointer>;\n", decl.dylan-name);
end;

define method write-declaration (decl :: <block-type-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  let stream = back-end.stream;
  register-written-name(back-end.written-names, decl.dylan-name, decl);

  format(stream, "define constant %s = <C-void*>;\n", decl.dylan-name);
end;

define method write-declaration (decl :: <vector-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  let stream = back-end.stream;
  register-written-name(back-end.written-names, decl.dylan-name, decl);

  format(stream, "define constant %s = %s;\n",
         decl.dylan-name, decl.pointer-equiv.dylan-name);
end;

define method write-declaration
    (decl :: <enum-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  let stream = back-end.stream;
  if (~decl.equated?)
    // This may still be an "incomplete type".  If so, we just define the class
    // as a synonym for <integer>
    if (~decl.anonymous?)
      format(stream, "define constant %s = <C-int>;\n", decl.dylan-name);
      register-written-name(back-end.written-names, decl.dylan-name, decl);
    end if;
    if (decl.members)
      for (literal in decl.members)
        let name = literal.dylan-name;
        let int-value = literal.constant-value;
        unless (instance?(int-value, <double-integer>))
          format(stream, "define constant %s = %d;\n", name, int-value);
          register-written-name(back-end.written-names, name, decl, subname?: #t);
        end;
      finally
        new-line(stream);
      end for;
    end if;
  end if;
end method write-declaration;

define method write-declaration
    (decl :: <enum-slot-declaration>, back-end :: <c-ffi-back-end>)
 => ();
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
    (decl :: <macro-declaration>, back-end :: <c-ffi-back-end>)
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
