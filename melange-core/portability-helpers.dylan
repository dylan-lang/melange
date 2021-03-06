module: portability
copyright: See LICENSE file in this distribution.

define function add-to-include-path (directories)
  for (dir in directories)
    push-last(include-path, dir);
  end for;
end function;

define function get-compiler-include-directories (cmd :: <string>)
  with-application-output (stream = cmd)
    let output = read-to-end(stream);
    split(strip(output), ":");
  end;
end function;

define function get-gcc-compiler-include-directories ()
  let cmd = "echo | gcc -Wp,-v -x c - -fsyntax-only 2>&1";
  with-application-output (stream = cmd)
    let output = read-to-end(stream);
    let lines = split(strip(output), "\n");
    let includes = make(<stretchy-vector>);
    do(method(line)
         let line = strip(line);
         if (~empty?(line) & line[0] = '/')
           add!(includes, line);
         end if;
       end, lines);
    includes
  end;
end function;

define function get-compiler-defines (cmd :: <string>)
  local method parse-define (line :: <string>)
          let define-start = size("#define ");
          let sep = find-substring(line, " ", start: define-start);
          let def = copy-sequence(line, start: define-start, end: sep);
          let val = copy-sequence(line, start: sep + 1);
          values(def, val)
        end;
  with-application-output (stream = cmd)
    let output = read-to-end(stream);
    let lines = split(strip(output), "\n");
    let defines = make(<stretchy-vector>);
    do(method(line)
        let (d, v) = parse-define(line);
        unless (find-substring(v, "##"))
          add!(defines, d);
          add!(defines, v);
        end;
       end, lines);
    defines
  end;
end function;

define constant $gcc-or-clang-defines
  = #[
      // Basics
      "const", "",
      "volatile", "",
      "restrict", "",
      "__restrict", "",

      "__signed__", "",
      "__signed", "",
      "__inline__", "",
      "__inline", "",
      "inline", "",
      "__builtin_va_list", "void*",

      "__extension__", "",

      // Parameterized macros which remove various GCC extensions from our
      // source code. The last item in the list is the right-hand side of
      // the define; all the items preceding it are named parameters.
      "__attribute__", #(#("x"), ""),
      "__asm__", #(#("x"), ""),
      "__asm", #(#("x"), ""),

      // These are various feature check macros that clang uses and are
      // used in Apple headers among other places.
      // They are documented here:
      // http://clang.llvm.org/docs/LanguageExtensions.html#feature-checking-macros
      "__has_attribute", #(#("x"), "0"),
      "__has_builtin", #(#("x"), "0"),
      "__has_declspec_attribute", #(#("x"), "0"),
      "__has_extension", #(#("x"), "0"),
      "__has_feature", #(#("x"), "0"),
      "__has_warning", #(#("x"), "0"),
      "__is_identifier", #(#("x"), "0")
      ];
