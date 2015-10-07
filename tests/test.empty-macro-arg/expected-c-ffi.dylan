module: test-empty-macro-arg

define C-function foo
  input parameter num_ :: <C-signed-int>;
  c-name: "foo";
end;

define C-function stdlibbar
  input parameter num_ :: <C-signed-int>;
  c-name: "stdlibbar";
end;

define C-function baz1
  c-name: "baz1";
end;

define C-function baz2
  c-name: "baz2";
end;

define C-function baz3
  c-name: "baz3";
end;

define C-function baz4
  c-name: "baz4";
end;

define C-function baz5
  c-name: "baz5";
end;

define C-function baz6
  c-name: "baz6";
end;

define C-function baz7
  c-name: "baz7";
end;

define C-function getpid
  result res :: <C-signed-int>;
  c-name: "getpid";
end;

define C-function foobar1
  result res :: <C-signed-int>;
  c-name: "foobar1";
end;

define C-function foobar2
  result res :: <C-signed-int>;
  c-name: "foobar2";
end;

define C-function acos
  input parameter __x_ :: <C-signed-int>;
  result res :: <C-double>;
  c-name: "acos";
end;

