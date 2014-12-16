module: test

define C-function a
  input parameter arg1_ :: <C-signed-int>;
  c-name: "a";
end;

define C-function b
  input parameter c_ :: <C-signed-int>;
  c-name: "b";
end;

define C-function d
  result res :: <C-signed-int>;
  c-name: "d";
end;

