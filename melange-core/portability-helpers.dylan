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
