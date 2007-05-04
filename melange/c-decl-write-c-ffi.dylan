module: c-declarations

define method write-declaration (decl :: <declaration>, back-end :: <c-ffi-back-end>)
 => ();
  format(back-end.stream, " /* Ignoring declaration for %= %=*/\n", decl, decl.dylan-name)
end;

define method write-declaration (decl :: <struct-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  register-written-name(back-end.written-names, decl.dylan-name, decl);
  let supers = decl.superclasses | #("<C-void*>");
  format(back-end.stream, "define C-subtype %s (%s) end;\n",
         decl.dylan-name, as(<byte-string>, apply(join, ", ", supers)));
end;

define method write-declaration (decl :: <union-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  register-written-name(back-end.written-names, decl.dylan-name, decl);
  let supers = decl.superclasses | #("<C-void*>");
  format(back-end.stream, "define C-subtype %s (%s) end;\n",
         decl.dylan-name, as(<byte-string>, apply(join, ", ", supers)));
end;

define method write-declaration (decl :: <pointer-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  unless (decl.dylan-name = decl.referent.dylan-name)
    register-written-name(back-end.written-names, decl.dylan-name, decl);
    format(back-end.stream, "define C-pointer-type %s => %s;\n",
           decl.dylan-name, decl.referent.dylan-name);
  end;
end;

define method write-declaration (decl :: <function-declaration>, back-end :: <c-ffi-back-end>)
 => ();
  let stream = back-end.stream;
  register-written-name(back-end.written-names, decl.dylan-name, decl);

  format(stream, "define C-function %s\n", decl.dylan-name);
  for (param in decl.type.parameters)
    unless (instance?(param, <varargs-declaration>))
      format(stream, "  %s parameter %s :: %s;\n", 
             select(param.direction)
               #"default", #"in" => "input";
               #"out" => "output";
               #"in-out" => "input output";
             end,
             param.dylan-name, param.type-name)
    end;
  end;
  let result-type = decl.type.result.type;
  if (result-type ~= void-type)
    format(stream, "  result res :: %s;\n", result-type.dylan-name);
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
    let type-name = decl.dylan-name;
    
    // This may still be an "incomplete type".  If so, we just define the class
    // as a synonym for <integer>
    format(stream, "define constant %s = <C-int>;\n", type-name);
    register-written-name(back-end.written-names, type-name, decl);
    if (decl.members)

      for (literal in decl.members)
	let name = literal.dylan-name;
	let int-value = literal.constant-value;
	format(stream, "define constant %s = %d;\n", name, int-value);
	register-written-name(back-end.written-names, name, decl, subname?: #t);
      finally
	new-line(stream);
      end for;
    end if;
  end if;
end method write-declaration;
  
