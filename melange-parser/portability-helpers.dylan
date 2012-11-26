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
