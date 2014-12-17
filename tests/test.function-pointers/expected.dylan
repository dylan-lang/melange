module: test

define constant <old-style-syntax-cb> = <C-function-pointer>;
define C-function old-style-syntax
  input parameter callback_ :: <old-style-syntax-cb>;
  result res :: <C-signed-int>;
  c-name: "old_style_syntax";
end;

define constant <new-style-syntax-cb> = <C-function-pointer>;
define C-pointer-type <new-style-syntax-cb*> => <new-style-syntax-cb>;
define C-function new-style-syntax
  input parameter callback_ :: <new-style-syntax-cb*>;
  result res :: <C-signed-int>;
  c-name: "new_style_syntax";
end;

define constant <anonymous-0> = <C-function-pointer>;
define C-function anonymous-non-typedef-function-pointer
  input parameter arg1_ :: <anonymous-0>;
  result res :: <C-signed-int>;
  c-name: "anonymous_non_typedef_function_pointer";
end;

define constant <old> = <C-function-pointer>;
define C-function non-typedef-function-pointer
  input parameter old_ :: <old>;
  result res :: <C-signed-int>;
  c-name: "non_typedef_function_pointer";
end;

