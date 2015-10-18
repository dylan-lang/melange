module: misc

define  class <A> (<statically-typed-pointer>) end;

define sealed inline-only method A$a
    (ptr :: <A>) => (result :: <integer>);
  signed-long-at(ptr, offset: 0);
end method A$a;

define sealed inline-only method A$a-setter
    (value :: <integer>, ptr :: <A>) => (result :: <integer>);
  signed-long-at(ptr, offset: 0) := value;
  value;
end method A$a-setter;

define sealed inline-only method A$b
    (ptr :: <A>) => (result :: <integer>);
  signed-long-at(ptr, offset: 4);
end method A$b;

define sealed inline-only method A$b-setter
    (value :: <integer>, ptr :: <A>) => (result :: <integer>);
  signed-long-at(ptr, offset: 4) := value;
  value;
end method A$b-setter;

define sealed inline-only method A$next
    (ptr :: <A>) => (result :: <A>);
  pointer-at(ptr, offset: 8, class: <A>);
end method A$next;

define sealed inline-only method A$next-setter
    (value :: <A>, ptr :: <A>) => (result :: <A>);
  pointer-at(ptr, offset: 8, class: <A>) := value;
  value;
end method A$next-setter;

define method pointer-value (value :: <A>, #key index = 0) => (result :: <A>);
  value + index * 12;
end method pointer-value;

define method content-size (value :: limited(<class>, subclass-of: <A>)) => (result :: <integer>);
  12;
end method content-size;

define constant anonymous-1 = find-c-function("takes_a");
define function takes-a
    (arg1 :: <A>)
 => ();
  anonymous-1(arg1);
  values();
end function takes-a;

