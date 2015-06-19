module: define-interface
copyright: See LICENSE file in this distribution.

//======================================================================
// interface.dylan contains the complete contents of module
// "define-interface".  This module provides the top level "program" for
// Melange.  It parses "interface definition" files (with a bit of help
// from "int-lexer" and "int-parse") and writes out Dylan code files (as well
// as possible auxiliary definition files), calling routines from "c-parse"
// and "c-declarations" to do most of the work.
//======================================================================

//----------------------------------------------------------------------
// Routines to scan the interface file for "define interface" forms.
//----------------------------------------------------------------------

// Create boyer-moore search engine for "define".  This should allow us to
// scan for define interface clauses very quickly.  (We can't just search for
// "define interface", since there may be variable numbers of spaces between
// the words.
//
define constant match-define = make-substring-positioner("define", #f);

define constant match-module = make-substring-positioner("module: ", #f);
define constant match-newline = make-substring-positioner("\n", #t);

// Check to see whether the specified "long" (sub-)string begins with the
// short string.  This routine should probably be in string-extensions
// somewhere, but it isn't yet.
//
define method is-prefix?
    (short :: <string>, long :: <string>, #key start = 0)
 => (result :: <boolean>);
  if (size(short) > size(long) - start)
    #f;
  else
    block (return)
      for (short-char in short, index from start)
        if (short-char ~== long[index]) return(#f) end if;
      end for;
      #t;
    end block;
  end if;
end method is-prefix?;

// Returns the number of contiguous whitespace characters which can be found
// starting at the given position in "string".
//
define method count-whitespace
    (string :: <string>, position :: <integer>) => (count :: <integer>);
  for (index from position below size(string),
       while: whitespace?(string[index]))
  finally
    index - position;
  end for;
end method count-whitespace;

// Reads the entire contents of "in-stream" and scans for "define interface"
// form.  Any text which is not in such a form is written to "out-stream"
// verbatim, while the contents of the "define interface" forms are passed
// (along with "out-stream") to "process-define-interface" which will do all
// the interesting work.
//
define method process-interface-file
    (in-file :: <string>, out-stream :: <stream>,
     #key verbose, structs, module-stream :: false-or(<stream>),
          defines, undefines) => ();
  let in-stream = make(<file-stream>, locator: in-file);
  let input-string = read-to-end(in-stream);
  let sz = input-string.size;
  let module-line-start = match-module(input-string);
  unless (module-line-start)
    error("Unable to find a module: keyword");
  end unless;
  let module-line-end = match-newline(input-string, start: module-line-start);

  let module-line
    = module-line-start
    & module-line-end
    & copy-sequence(input-string,
                    start: module-line-start + 8,
                    end: module-line-end + 1);

  local method try-define (position :: <integer>) => ();
          let new-position = match-define(input-string, start: position);
          write(out-stream, input-string, start: position,
                end: new-position | sz);
          if (new-position)
            let index = new-position + 6;
            let space-count = count-whitespace(input-string, index);
            if (space-count > 0
                  & is-prefix?("interface", input-string,
                               start: index + space-count))
              let newer-position
                = process-define-interface(in-file, input-string,
                                           new-position, out-stream,
                                           verbose: verbose,
                                           module-stream: module-stream,
                                           module-line: module-line,
                                           defines: defines,
                                           undefines: undefines);
              if (newer-position < sz) try-define(newer-position) end if;
            else
              write(out-stream, input-string, start: new-position,
                    end: index + space-count);
              try-define(index + space-count);
            end if;
          end if;
        end method try-define;
  try-define(0);
  force-output(out-stream);
  if (verbose)
    write-line(*standard-error*, "");
    force-output(*standard-error*);
  end if;
end method process-interface-file;

//----------------------------------------------------------------------
// Support routines for "process-define-interface"
//----------------------------------------------------------------------

// Type dependent handling for "clauses" within the define interface.  These
// include "function", "struct", "union", "pointer", "variable" and "constant"
// clauses.  "#include" clauses are handled directly by
// "process-define-interface".
//
// These methods may retrieve and annotate declarations from "c-state", thus
// modifying the behavior of "write-declaration".
//
define generic process-clause
    (clause :: <clause>, state :: <parse-state>, c-state :: <c-parse-state>)
 => ();

//------------------------------------------------------------------------

// Handles the different types of mapping: type renaming, type mapping, and
// type equation.  "find-decl" should be a function which maps a string into a
// declaration -- likely this will be a curried call to "parse-type" or
// "find-slot".
//
define method process-mappings
    (options :: <container-options>, find-decl :: <function>) => ();
  // Note that duplicate renamings will be accepted the last rename/equate for
  // a type will supersede all others.
  for (mapping in options.renames)
    let decl = mapping.head.find-decl;
    decl & rename(decl, as(<string>, mapping.tail));
  end for;
  for (mapping in options.mappings)
    let decl = mapping.head.find-decl;
    decl & remap(decl, as(<string>, mapping.tail));
  end for;
  for (mapping in options.equates)
    let decl = mapping.head.find-decl;
    decl & equate(decl, as(<string>, mapping.tail));
  end for;
end method process-mappings;

// Processes top-level "import:" and "exclude:" options, producing an
// "imports" table to be passed to declaration-closure.  The table is keyed by
// the declaration itself and will contain either #t or a renaming for every
// explicitly imported declaration, #f for every explicitly excluded
// declarations, and be undefined for others.  "Import-all?" can be used to
// determine whether to import declarations which are not explicitly named.
//
// "find-decl" should be a mapping from strings to declarations -- likely a
// curried call to either "parse-type" or "find-slot".
//
define method process-imports
    (options :: <container-options>, find-decl :: <function>)
 => (imports :: <table>, import-all? :: <boolean>,
     file-imports :: <table>);

  local method process-imports-aux(decl-sequence :: <sequence>,
                                   import-table :: <table>)
          for (import in decl-sequence)
            if (instance?(import, <pair>))
              let decl = import.head.find-decl;
              decl & (import-table[decl] := as(<string>, import.tail));
            else
              let decl = import.find-decl;
              decl & (import-table[decl] := #t);
            end if;
          end for;
        end method process-imports-aux;

  let imports = make(<table>);
  process-imports-aux(options.global-imports, imports);
  let import-all? :: <boolean> = (options.global-import-mode ~== #"none");

  let file-imps = make(<string-table>);
  for (imp-sequence keyed-by file in options.file-imports)
    let new-table = (file-imps[file] := make(<table>));
    process-imports-aux(imp-sequence, new-table);
  end for;

  do(method (name)
       let decl = find-decl(name);
       if (decl)
         exclude-decl(decl);
         imports[decl] := #f;
       end if;
     end method, options.exclude);
  values(imports, import-all?, file-imps);
end method process-imports;

// Given one or more <container-options>s, merge them all together (with
// conflicts resolving to the first <container-option> which gives a value for
// the particular field) and fill in defaults for any unspecified fields.
//
define method merge-container-options
    (first :: <container-options>, #rest rest)
 => (mapper :: <function>, prefix :: <string>, read-only :: <boolean>,
     sealing :: <string>, inline :: <string>,
     ptr-type-name :: false-or(<symbol>));
  let mapper = first.name-mapper;
  let pre = first.prefix;
  let rd-only = first.read-only;
  let sealing = first.seal-string;
  let inline = first.inline-string;
  let ptr-type-name = first.pointer-type-name;
  for (next in rest)
    if (mapper == undefined) mapper := next.name-mapper end if;
    if (pre == undefined) pre := next.prefix end if;
    if (rd-only == undefined) rd-only := next.read-only end if;
    if (sealing == undefined) sealing := next.seal-string end if;
    if (inline == undefined) inline := next.inline-string end if;
    if (ptr-type-name == undefined) ptr-type-name := next.pointer-type-name end if;
  end for;
  if (mapper == undefined)
    mapper := #"minimal-name-mapping-with-structure-prefix";
  end if;
  if (pre == undefined) pre := "" end if;
  if (rd-only == undefined) rd-only := #f end if;
  if (sealing == undefined) sealing := "sealed" end if;
  if (inline == undefined) inline := "" end if;
  if (ptr-type-name == undefined) ptr-type-name := #f end if;
  values(curry(map-name, mapper), pre, rd-only, sealing, inline, ptr-type-name);
end method merge-container-options;

//----------------------------------------------------------------------
// Type specific methods for "process-clause".
//----------------------------------------------------------------------

define method process-clause
    (clause :: <function-clause>, state :: <parse-state>,
     c-state :: <c-parse-state>)
 => ();
  let decl = parse-type(clause.name, c-state);
  if (~instance?(decl, <function-declaration>))
    error("Function clause names a non-function: %s", clause.name);
  end if;
  for (option in clause.options)
    let tag = option.head;
    let body = option.tail;
    select (tag)
      #"equate-result" =>
        equate(decl.find-result, body);
      #"map-result" =>
        remap(decl.find-result, body);
      #"map-error-result" =>
        if (body) decl.find-result.error-result? := #t end if;
        remap(decl.find-result, body);
      #"ignore-result" =>
        if (body) decl.find-result.ignored? := #t end if;
      #"equate-arg" =>
        equate(find-parameter(decl, body.head), body.tail);
      #"map-arg" =>
        remap(find-parameter(decl, body.head), body.tail);
      #"inline" =>
        decl.inlined-string := body;
      otherwise =>
        find-parameter(decl, body).argument-direction := tag;
    end select;
  end for;
end method process-clause;

define method process-clause
    (clause :: <variable-clause>, state :: <parse-state>,
     c-state :: <c-parse-state>)
 => ();
  let decl = parse-type(clause.name, c-state);
  if (~instance?(decl, <variable-declaration>))
    error("Variable clause names a non-variable: %s", clause.name);
  end if;
  for (option in clause.options)
    let tag = option.head;
    let body = option.tail;
    select (tag)
      #"setter" => if (body) decl.setter := body else decl.read-only := #t end;
      #"getter" => decl.getter := body;
      #"read-only" => decl.read-only := body;
      #"seal" => decl.sealed-string := body;
      #"equate" => equate(decl, body);
      #"map" => remap(decl, body);
    end select;
  end for;
end method process-clause;

define method process-clause
    (clause :: <constant-clause>, state :: <parse-state>,
     c-state :: <c-parse-state>)
 => ();
  let decl = parse-type(clause.name, c-state);
  if (~instance?(decl, <constant-declaration>))
    error("Constant clause names a non-constant: %s", clause.name);
  end if;
  for (option in clause.options)
    let tag = option.head;
    let body = option.tail;
    select (tag)
      #"value" => decl.constant-value := body;
    end select;
  end for;
end method process-clause;

define method process-clause
    (clause :: <struct-clause>, state :: <parse-state>,
     c-state :: <c-parse-state>)
 => ();
  let decl = parse-type(clause.name, c-state);
  if (instance?(decl, <typedef-declaration>)) decl := true-type(decl) end if;
  if (~instance?(decl, <struct-declaration>))
    error("Struct clause names a non-struct: %s", clause.name);
  end if;

  let (#rest opts) = merge-container-options(clause.container-options,
                                             state.container-options);
  apply(apply-container-options, decl, opts);

  let find-decl = protect(curry(find-slot, decl));
  process-mappings(clause.container-options, find-decl);
  let (imports, import-all?) = process-imports(clause.container-options,
                                               find-decl);
  exclude-slots(decl, imports, import-all?);
  for (option in clause.options)
    let tag = option.head;
    let body = option.tail;
    select (tag)
      #"superclass" =>
//  This should be done in the back end instead
//        let supers
//          = if (member?("<statically-typed-pointer>", body, test: \=))
//              body
//            else
//              concatenate(body, #("<statically-typed-pointer>"));
//            end if;
        decl.superclasses := body;
    end select;
  end for;
end method process-clause;

define method process-clause
    (clause :: <union-clause>, state :: <parse-state>,
     c-state :: <c-parse-state>)
 => ();
  let decl = parse-type(clause.name, c-state);
  if (instance?(decl, <typedef-declaration>)) decl := true-type(decl) end if;
  if (~instance?(decl, <union-declaration>))
    error("Union clause names a non-union: %s", clause.name);
  end if;
  let (#rest opts) = merge-container-options(clause.container-options,
                                             state.container-options);
  apply(apply-container-options, decl, opts);

  let find-decl = protect(curry(find-slot, decl));
  process-mappings(clause.container-options, find-decl);
  let (imports, import-all?) = process-imports(clause.container-options,
                                               find-decl);
  exclude-slots(decl, imports, import-all?);
  for (option in clause.options)
    let tag = option.head;
    let body = option.tail;
    select (tag)
      #"superclass" =>
        let supers = if (member?("<statically-typed-pointer>", body))
                       body
                     else
                       concatenate(body, #("<statically-typed-pointer>"));
                     end if;
        decl.superclasses := supers;
    end select;
  end for;
end method process-clause;

define method process-clause
    (clause :: <pointer-clause>, state :: <parse-state>,
     c-state :: <c-parse-state>)
 => ();
  let decl = parse-type(clause.name, c-state);
  if (instance?(decl, <pointer-declaration>)) decl := true-type(decl) end if;
  if (~instance?(decl,
                 type-union(<pointer-declaration>, <vector-declaration>)))
    error("Pointer clause names a non-pointer: %s", clause.name);
  end if;

  for (option in clause.options)
    let tag = option.head;
    let body = option.tail;
    select (tag)
      #"superclass" =>
        if (instance?(decl, <vector-declaration>))
          let supers = concatenate(body, list(decl.pointer-equiv.dylan-name,
                                              "<c-vector>",
                                              "<statically-typed-pointer>"));
          decl.superclasses := remove-duplicates!(supers);
        else
          let supers = if (member?("<statically-typed-pointer>", body))
                         body;
                       else
                         concatenate(body, #("<statically-typed-pointer>"));
                       end if;
          decl.superclasses := supers;
        end if;
    end select;
  end for;
end method process-clause;

define method process-clause
    (clause :: <function-type-clause>, state :: <parse-state>,
     c-state :: <c-parse-state>)
 => ()

  // Look up our type and make sure it's a function typedef.
  let decl = parse-type(clause.name, c-state).true-type;
  if (instance?(decl, <pointer-declaration>))
    // snap past a single level of indirection if present
    decl := decl.referent;
  end if;
  unless (instance?(decl, <function-type-declaration>))
    error("melange: %= is not a function type", decl);
  end unless;

  // Define a proper name mapper.
  // XXX - This needs to be integrated with the real name-mapper system.
  // The current implementation is a hack and causes no end of problems.
  let (mapper, prefix) = merge-container-options(state.container-options);
  decl.local-name-mapper :=
    method (alternate-prefix, name)
      concatenate(alternate-prefix, "-",
                  mapper(#"function", prefix, name, #()));
    end;

  // Process our options.
  for (option in clause.options)
    let tag = option.head;
    let body = option.tail;
    select (tag)
      #"callback-maker" =>
        decl.callback-maker-name := body;
      #"callout-function" =>
        decl.callout-function-name := body;
      otherwise => #f;
    end select;
  end for;
end method process-clause;

//----------------------------------------------------------------------
// High level processing routines for interface definitions
//----------------------------------------------------------------------

define variable target-switch :: <symbol> = #"c-ffi";

// Process-parse-state does all necessary processing for the required
// "#include" clause and invokes process clause for all other clauses in the
// interface definition.
//
// When all of the clauses have been processed, we end up with a list of
// annotated declarations.  These are passed, along with out-stream, to
// write-declaration for final processing.
//
define method process-parse-state
    (state :: <parse-state>, out-stream :: <stream>,
     #key verbose, structs, module-stream :: false-or(<stream>),
     module-line, defines: cmd-defines, undefines: cmd-undefines)
 => ();
  if (~state.include-files)
    error("Missing #include in 'define interface'");
  end if;
  let full-names = make(<vector>, size: state.include-files.size);
  for (name in state.include-files, index from 0)
    let full-name = file-in-include-path(name);
    unless (full-name) error("File not found: %s", name) end;
    full-names[index] := full-name;
  end for;

  let defines = make(<string-table>);
  for (i from 0 below $default-defines.size by 2)
    defines[$default-defines[i]] := $default-defines[i + 1];
  end for;
  for (value keyed-by name in cmd-defines)
    if (value == #t)
      defines[name] := "1";
    else
      defines[name] := value
    end;
  end for;
  for (def in $default-undefines)
    remove-key!(defines, def);
  end for;
  for (def in cmd-undefines)
    remove-key!(defines, def);
  end for;
  for (def in state.macro-defines)
    defines[def.head] := def.tail;
  end for;
  for (def in state.macro-undefines)
    remove-key!(defines, def);
  end for;

  let c-state
    = c-parse(full-names, defines: defines, verbose: verbose);

  // The ordering of some of the following steps is important.  We must
  // process all of the clauses before doing apply-options so that any
  // rename, etc. options will preempt the "default" values computed during
  // apply-options.  Apply-options must be also be called before
  // write-declaration but after declaration-closure, since each of these
  // depends upon the results of the last.

  let find-decl = protect(rcurry(parse-type, c-state));
  process-mappings(state.container-options, find-decl);
  do(protect(rcurry(process-clause, state, c-state)), state.clauses);

  let (imports, import-all?, file-imports)
    = process-imports(state.container-options, find-decl);
  let decls = declaration-closure(c-state, full-names,
                                  state.container-options.excluded-files,
                                  imports,
                                  file-imports,
                                  state.container-options.global-import-mode,
                                  state.container-options.file-import-modes);
  let (#rest opts) = merge-container-options(state.container-options);
  for (decl in decls)
    apply(apply-options, decl, opts)
  end for;
  let back-end = make-backend-for-target(target-switch, out-stream);
  do(rcurry(write-declaration, back-end), decls);
  write-module-stream(back-end.written-names, module-stream, module-line);
end method process-parse-state;

// Write an export module file

define method write-module-stream
    (written-name-record :: <written-name-record>, module-stream :: false-or(<stream>),
     module-line :: false-or(<string>)) => ()
  let names :: <sequence> = all-written-names(written-name-record);
  if (module-stream & names.size > 0)
    format(module-stream, "module: dylan-user\n\n");
    if (module-line)
      format(module-stream, "define module %s", module-line)
    else
      format(module-stream, "define module foo", module-line)
    end if;
    format(module-stream,
           "  use common-dylan;\n"
           "  use c-ffi;\n"
           "  export");
                // The names are returned in hash order, so we sort them before writing them
                names := sort!(names, test: method(a, b) as(<string>, a) < as(<string>, b) end);
    for (separator = "" then ",", name in names)
      // If a type is created in the module, export it
      format(module-stream, concatenate(separator, "\n    %s"), name);
      force-output(module-stream);
    end for;
    format(module-stream, ";\nend module;\n");
    force-output(module-stream);
  end if;
end method write-module-stream;

// Process-define-interface simply calls the parser in int-parse to decipher
// the "define interface" and then call "process-parse-state" to annotate and
// write out the declarations.  It returns the character position of the first
// token after the interface definition.
//
define method process-define-interface
    (file-name :: <string>, string :: <string>, start :: <integer>,
     out-stream :: <stream>,
     #key verbose, module-stream :: false-or(<stream>),
     module-line, defines, undefines)
 => (end-position :: <integer>);
  let tokenizer = make(<tokenizer>, source-string: string,
                       source-file: file-name, start: start);
  let state = make(<parse-state>, tokenizer: tokenizer);
  // If there is a problem with the parse, it will simply signal an error
  parse(state);
  process-parse-state(state, out-stream,
                      verbose: verbose,
                      module-stream: module-stream,
                      module-line: module-line,
                      defines: defines,
                      undefines: undefines);
  // The tokenizer will be set at the next token after the "define
  // interface".  We can't just call tokenizer.position since there may have
  // been an "unget-token" call.
  get-token(tokenizer).position;
end method process-define-interface;


// establish a protection boundary against unhandled conditions,
// returning a function that behaves just like the original function,
// except that it returns #f when catching an unhandled condition
//
define function protect (f :: <function>) => (f* :: <function>)
  method (#rest arguments)
    block ()
      apply(f, arguments)
    exception(condition :: <condition>)
      format(*standard-error*, "%s\n", condition);
      format(*standard-error*, "while calling %= with %=\n", f, arguments);
      force-output(*standard-error*);
      #f
    end block
  end method
end function protect;

//----------------------------------------------------------------------
// Built-in help.
//----------------------------------------------------------------------

define method show-copyright (stream :: <stream>) => ()
  format(stream, "Melange (OpenDylan)\n");
  format(stream, "Turns C headers into Dylan libraries.\n");
  format(stream, "Copyright 1994-1997 Carnegie Mellon University\n");
  format(stream, "Copyright 1998-2004 Gwydion Dylan Maintainers\n");
  format(stream, "Copyright 2005-2012 Dylan Hackers\n");
end method show-copyright;

define method show-usage (stream :: <stream>) => ()
  format(stream,
"Usage: melange [-v] [--headers]\n"
"               [--c-ffi|--debug|--Ttarget]\n"
"               [-Ddef[=val]...] [-Uundef...]\n"
"               [-Iincdir...] [--framework name...]\n"
"               [-m modulefile] infile [outfile]\n"
"       melange --defines\n"
"       melange --undefines\n"
"       melange --includes\n"
"       melange --help\n"
"       melange --version\n");
end method show-usage;

define method show-usage-and-exit () => ()
  show-usage(*standard-error*);
  exit-application(1);
end method show-usage-and-exit;

define method show-default-defines (stream :: <stream>) => ()
  for (i from 0 below $default-defines.size by 2)
    let name = $default-defines[i];
    let value = $default-defines[i + 1];

    if (instance?(value, <string>))
      // Print a simple macro: NAME value
      format(stream,
"%s %s\n", name, value);
    elseif (instance?(value, <list>))
      // Print a parameterized macro: NAME(arg1, arg2) value
      format(stream,
"%s(", name);
      for (arg in value[0],
           fmt = "%s" then ", %s")
        format(stream, fmt, arg);
      end for;
      format(stream, ") %s\n", value[1]);
    end if;
  end for;
end method show-default-defines;

define method show-default-undefines (stream :: <stream>) => ()
  for (undef in $default-undefines)
    format(stream, "%s\n", undef);
  end for;
end method show-default-undefines;

define method show-default-includes (stream :: <stream>) => ()
  for (i from 0 below include-path.size)
    let name = include-path[i];
    format(stream, "%s\n", name);
  end for;
end method show-default-includes;

define method show-help (stream :: <stream>) => ()
  show-copyright(stream);
  format(stream, "\n");
  show-usage(stream);
  format(stream, "\n"
"Options:\n"
"  -v, --verbose          Print progress messages while parsing.\n"
"                         (Includes --headers.)\n"
"  --headers              Print each header file included while parsing.\n"
"  --c-ffi                Generate output for use only with Open Dylan.\n"
"  --debug                Generate a debug dump of the parsed C declarations.\n"
"  -T, --target           Generate output for use only with the named target.\n"
"  -D, --define           Define a C preprocessor macro for use by C headers.\n"
"                         If no value is given, defaults to 1.\n"
"  -U, --undefine         Prevent definition of a default preprocessor macro.\n"
"                         (Use --defines to see the defaults. Use --undefines to"
"                         see the default undefines.)\n"
"  -I, --includedir       Extra directories to search for C headers.\n"
"  --framework            The name of a framework bundle to search for C headers\n"
"                         and child frameworks. Required when a child framework\n"
"                         is directly referred to in an interface definition\n"
"                         with no previous references to its parent; once a\n"
"                         parent is seen,either via this option or in a clause\n"
"                          of the interface definition, its children will be\n"
"                         found automatically. (Note: Parent --framework\n"
"                         options must be given before child framework options.)\n"
"  -m, --module-file      Create a Dylan interchange file with a module\n"
"                         definition that exports the interface names.\n"
"  --defines              Show the default C preprocessor definitions.\n"
"  --undefines            Show the default platform undefinitions.\n"
"  --includes             Show the default C preprocessor include directories.\n"
"  --help                 Show this help text.\n"
"  --version              Show version number.\n"
);
end method show-help;


//----------------------------------------------------------------------
// The main program
//----------------------------------------------------------------------

// Processes all "interface file"s specified on the command line, writing the
// results to *standard-output*.  The user may also specify additional
// "include" directories by means of a "-Idirectory" switch.
//

define method main (program, args)
  // Describe our arguments and create appropriate parser objects.
  let *argp* = make(<command-line-parser>);
  add-option(*argp*,
             make(<flag-option>,
                  names: #("help", "h")));
  add-option(*argp*,
             make(<flag-option>,
                  names: #("version")));
  add-option(*argp*,
             make(<flag-option>,
                  names: #("defines")));
  add-option(*argp*,
             make(<flag-option>,
                  names: #("undefines")));
  add-option(*argp*,
             make(<flag-option>,
                  names: #("includes")));
  add-option(*argp*,
             make(<flag-option>,
                  names: #("verbose", "v")));
  add-option(*argp*,
             make(<flag-option>,
                  names: #("headers")));
  add-option(*argp*,
             make(<flag-option>,
                  names: #("debug")));
  add-option(*argp*,
             make(<flag-option>,
                  names: #("c-ffi")));
  add-option(*argp*,
             make(<parameter-option>,
                  names: #("target", "T")));
  add-option(*argp*,
             make(<parameter-option>,
                  names: #("module-file", "m")));
  add-option(*argp*,
             make(<repeated-parameter-option>,
                  names: #("includedir", "I")));
  add-option(*argp*,
             make(<keyed-option>,
                  names: #("define", "D")));
  add-option(*argp*,
             make(<repeated-parameter-option>,
                  names: #("undefine", "U")));
  add-option(*argp*,
             make(<repeated-parameter-option>,
                  names: #("framework")));

  // Parse our command-line arguments.
  block ()
    parse-command-line(*argp*, args);
  exception (ex :: <usage-error>)
    show-usage-and-exit();
  end;

  // Handle our informational options.
  if (get-option-value(*argp*, "defines"))
    show-default-defines(*standard-output*);
    exit-application(0);
  end if;
  if (get-option-value(*argp*, "undefines"))
    show-default-undefines(*standard-output*);
    exit-application(0);
  end if;
  if (get-option-value(*argp*, "includes"))
    show-default-includes(*standard-output*);
    exit-application(0);
  end if;
  if (get-option-value(*argp*, "help"))
    show-help(*standard-output*);
    exit-application(0);
  end if;
  if (get-option-value(*argp*, "version"))
    show-copyright(*standard-output*);
    exit-application(0);
  end if;

  // Retrieve our regular options.
  let verbose? = get-option-value(*argp*, "verbose");
  let headers? = get-option-value(*argp*, "headers");
  let debug? = get-option-value(*argp*, "debug");
  let c-ffi? = get-option-value(*argp*, "c-ffi");
  let target = get-option-value(*argp*, "target");
  let module-file = get-option-value(*argp*, "module-file");
  let include-dirs = get-option-value(*argp*, "includedir");
  let defines = get-option-value(*argp*, "define");
  let undefines = get-option-value(*argp*, "undefine");
  let regular-args = positional-options(*argp*);
  let framework-dirs = get-option-value(*argp*, "framework");

  // Handle --headers.
  if (headers?)
    *show-parse-progress-level* := $parse-progress-level-headers;
  end if;

  // Handle --verbose; overrides --headers.
  if (verbose?)
    *show-parse-progress-level* := $parse-progress-level-all;
  end if;

  // Handle --c-ffi, --debug, -T.
  if (size(choose(identity, list(c-ffi?, debug?, target))) > 1)
    format(*standard-error*,
           "melange: only one of --c-ffi, --debug or -T may be specified.\n");
    show-usage-and-exit();
  end if;
  target-switch :=
    case
      c-ffi? => #"c-ffi";
      debug? => #"debug";
      target => as(<symbol>, target);
      otherwise => target-switch;
    end case;

  // Handle -I.
  // translate \ to /, because \ does bad things when inside a
  // string literal, like c-include("d:\foo\bar.h")
  include-dirs := map(rcurry(replace-substrings, "\\\\", "/"), include-dirs);
  for (dir in include-dirs)
    push(include-path, dir);
  end for;
  push(include-path, "./");

  // Handle --framework.
  for (dir in framework-dirs)
    *framework-paths* := add(*framework-paths*, dir);
  end for;
  find-frameworks(*framework-paths*);

  // Handle regular arguments.
  let in-file = #f;
  let out-file = #f;
  select (regular-args.size)
    1 =>
      in-file := regular-args[0];
    2 =>
      in-file := regular-args[0];
      out-file := make(<file-stream>,
                       locator: regular-args[1],
                       direction: #"output");
    otherwise =>
      show-usage-and-exit();
  end select;

  let module-stream = module-file & make(<file-stream>,
                                         locator: module-file,
                                         direction: #"output");


  // Do our real work.
  process-interface-file(in-file, out-file | *standard-output*,
                         verbose: verbose?,
                         module-stream: module-stream,
                         defines: defines,
                         undefines: undefines);
end method main;
