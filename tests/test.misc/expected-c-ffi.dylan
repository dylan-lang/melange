module: misc

define C-pointer-type <A*> => <A>;
define C-struct <A>
  sealed slot A$a :: <C-signed-int>;
  sealed slot A$b :: <C-signed-int>;
  sealed slot A$next :: <A*>;
end;

define C-function takes-a
  input parameter a_ :: <A*>;
  c-name: "takes_a";
end;

