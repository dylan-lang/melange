module: sizet

define constant <__darwin-size-t> = <integer>;

define constant <size-t> = <__darwin-size-t>;

define constant anonymous-1
  = constrain-c-function(find-c-function("sizeof_x"), #(), #t, list(<size-t>));
define function sizeof-x
    (arg1 :: <size-t>)
 => (result :: <size-t>);
  let result-value
    = anonymous-1(arg1);
  values(result-value);
end function sizeof-x;

define constant <__darwin-ssize-t> = <integer>;

define constant <ssize-t> = <__darwin-ssize-t>;

define  class <test-struct> (<statically-typed-pointer>) end;

define sealed inline-only method test_struct$size
    (ptr :: <test-struct>) => (result :: <size-t>);
  unsigned-long-at(ptr, offset: 0);
end method test_struct$size;

define sealed inline-only method test_struct$size-setter
    (value :: <size-t>, ptr :: <test-struct>) => (result :: <size-t>);
  unsigned-long-at(ptr, offset: 0) := value;
  value;
end method test_struct$size-setter;

define sealed inline-only method test_struct$ssize
    (ptr :: <test-struct>) => (result :: <ssize-t>);
  signed-long-at(ptr, offset: 4);
end method test_struct$ssize;

define sealed inline-only method test_struct$ssize-setter
    (value :: <ssize-t>, ptr :: <test-struct>) => (result :: <ssize-t>);
  signed-long-at(ptr, offset: 4) := value;
  value;
end method test_struct$ssize-setter;

define method pointer-value (value :: <test-struct>, #key index = 0) => (result :: <test-struct>);
  value + index * 8;
end method pointer-value;

define method content-size (value :: limited(<class>, subclass-of: <test-struct>)) => (result :: <integer>);
  8;
end method content-size;

