module: test

define C-struct <a>
  slot a$a :: <C-signed-int>;
  slot a$b :: <C-float>;
end;

define C-struct <c-b>
  slot b-c :: <C-signed-char>;
  slot b-d :: <C-double>;
end;

define C-struct <read-only>
  constant slot read-only$a :: <C-signed-int>;
  constant slot read-only$b :: <C-float>;
end;

