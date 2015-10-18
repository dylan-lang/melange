module: test

define  class <default-sealing> (<statically-typed-pointer>) end;

define sealed inline-only method default_sealing$a
    (ptr :: <default-sealing>) => (result :: <integer>);
  signed-long-at(ptr, offset: 0);
end method default_sealing$a;

define sealed inline-only method default_sealing$a-setter
    (value :: <integer>, ptr :: <default-sealing>) => (result :: <integer>);
  signed-long-at(ptr, offset: 0) := value;
  value;
end method default_sealing$a-setter;

define sealed inline-only method default_sealing$b
    (ptr :: <default-sealing>) => (result :: <integer>);
  signed-long-at(ptr, offset: 4);
end method default_sealing$b;

define sealed inline-only method default_sealing$b-setter
    (value :: <integer>, ptr :: <default-sealing>) => (result :: <integer>);
  signed-long-at(ptr, offset: 4) := value;
  value;
end method default_sealing$b-setter;

define method pointer-value (value :: <default-sealing>, #key index = 0) => (result :: <default-sealing>);
  value + index * 8;
end method pointer-value;

define method content-size (value :: limited(<class>, subclass-of: <default-sealing>)) => (result :: <integer>);
  8;
end method content-size;

define  class <sealed> (<statically-typed-pointer>) end;

define sealed inline-only method sealed$c
    (ptr :: <sealed>) => (result :: <integer>);
  signed-long-at(ptr, offset: 0);
end method sealed$c;

define sealed inline-only method sealed$c-setter
    (value :: <integer>, ptr :: <sealed>) => (result :: <integer>);
  signed-long-at(ptr, offset: 0) := value;
  value;
end method sealed$c-setter;

define sealed inline-only method sealed$d
    (ptr :: <sealed>) => (result :: <single-float>);
  float-at(ptr, offset: 4);
end method sealed$d;

define sealed inline-only method sealed$d-setter
    (value :: <single-float>, ptr :: <sealed>) => (result :: <single-float>);
  float-at(ptr, offset: 4) := value;
  value;
end method sealed$d-setter;

define method pointer-value (value :: <sealed>, #key index = 0) => (result :: <sealed>);
  value + index * 8;
end method pointer-value;

define method content-size (value :: limited(<class>, subclass-of: <sealed>)) => (result :: <integer>);
  8;
end method content-size;

define  class <open> (<statically-typed-pointer>) end;

define open inline-only method open$e
    (ptr :: <open>) => (result :: <integer>);
  signed-long-at(ptr, offset: 0);
end method open$e;

define open inline-only method open$e-setter
    (value :: <integer>, ptr :: <open>) => (result :: <integer>);
  signed-long-at(ptr, offset: 0) := value;
  value;
end method open$e-setter;

define method pointer-value (value :: <open>, #key index = 0) => (result :: <open>);
  value + index * 4;
end method pointer-value;

define method content-size (value :: limited(<class>, subclass-of: <open>)) => (result :: <integer>);
  4;
end method content-size;

