module: test

define C-struct <default-sealing>
  sealed slot default-sealing$a :: <C-signed-int>;
  sealed slot default-sealing$b :: <C-signed-int>;
end;

define C-struct <sealed>
  sealed slot sealed$c :: <C-signed-int>;
  sealed slot sealed$d :: <C-float>;
end;

define C-struct <open>
  open slot open$e :: <C-signed-int>;
end;

