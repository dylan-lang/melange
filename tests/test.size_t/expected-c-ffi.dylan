module: sizet

define C-function sizeof-x
  input parameter x_ :: <C-size-t>;
  result res :: <C-size-t>;
  c-name: "sizeof_x";
end;

define C-struct <test-struct>
  sealed slot test-struct$size :: <C-size-t>;
  sealed slot test-struct$ssize :: <C-ssize-t>;
end;

