module: test

define C-struct <a>
  sealed slot a$a :: <C-signed-int>;
  sealed slot a$b :: <C-float>;
  pointer-type-name: <a*>;
end;

define C-struct <c-b>
  sealed slot b-c :: <C-signed-char>;
  sealed slot b-d :: <C-double>;
  pointer-type-name: <yep>;
end;

define C-function foo
  input parameter arg1_ :: <yep>;
  c-name: "foo";
end;

define C-struct <read-only>
  constant sealed slot read-only$a :: <C-signed-int>;
  constant sealed slot read-only$b :: <C-float>;
end;

