module: test

define C-struct <a>
  sealed slot a$a :: <C-signed-int>;
  sealed slot a$b :: <C-float>;
end;

define C-struct <c-b>
  sealed slot b-c :: <C-signed-char>;
  sealed slot b-d :: <C-double>;
end;

define C-struct <read-only>
  constant sealed slot read-only$a :: <C-signed-int>;
  constant sealed slot read-only$b :: <C-float>;
end;

define C-struct <invisible-typedef>
  sealed slot invisible-typedef$a :: <C-signed-int>;
end;

define C-struct <array-slot>
  sealed array slot array-slot$a :: <C-signed-int>, length: 2;
end;

define C-struct <d>
  sealed slot d$f :: <C-float>;
end;

define C-struct <pqNotify>
  sealed slot pqNotify$f :: <C-float>;
end;

