module: test

define  class <a> (<statically-typed-pointer>) end;

define sealed inline-only method a$a
    (ptr :: <a>) => (result :: <integer>);
  signed-long-at(ptr, offset: 0);
end method a$a;

define sealed inline-only method a$a-setter
    (value :: <integer>, ptr :: <a>) => (result :: <integer>);
  signed-long-at(ptr, offset: 0) := value;
  value;
end method a$a-setter;

define sealed inline-only method a$b
    (ptr :: <a>) => (result :: <single-float>);
  float-at(ptr, offset: 4);
end method a$b;

define sealed inline-only method a$b-setter
    (value :: <single-float>, ptr :: <a>) => (result :: <single-float>);
  float-at(ptr, offset: 4) := value;
  value;
end method a$b-setter;

define method pointer-value (value :: <a>, #key index = 0) => (result :: <a>);
  value + index * 8;
end method pointer-value;

define method content-size (value :: limited(<class>, subclass-of: <a>)) => (result :: <integer>);
  8;
end method content-size;

define  class <c-b> (<statically-typed-pointer>) end;

define sealed inline-only method b-c
    (ptr :: <c-b>) => (result :: <integer>);
  signed-byte-at(ptr, offset: 0);
end method b-c;

define sealed inline-only method b-c-setter
    (value :: <integer>, ptr :: <c-b>) => (result :: <integer>);
  signed-byte-at(ptr, offset: 0) := value;
  value;
end method b-c-setter;

define sealed inline-only method b-d
    (ptr :: <c-b>) => (result :: <double-float>);
  double-at(ptr, offset: 8);
end method b-d;

define sealed inline-only method b-d-setter
    (value :: <double-float>, ptr :: <c-b>) => (result :: <double-float>);
  double-at(ptr, offset: 8) := value;
  value;
end method b-d-setter;

define method pointer-value (value :: <c-b>, #key index = 0) => (result :: <c-b>);
  value + index * 16;
end method pointer-value;

define method content-size (value :: limited(<class>, subclass-of: <c-b>)) => (result :: <integer>);
  16;
end method content-size;

define  class <read-only> (<statically-typed-pointer>) end;

define sealed inline-only method read_only$a
    (ptr :: <read-only>) => (result :: <integer>);
  signed-long-at(ptr, offset: 0);
end method read_only$a;

define sealed inline-only method read_only$b
    (ptr :: <read-only>) => (result :: <single-float>);
  float-at(ptr, offset: 4);
end method read_only$b;

define method pointer-value (value :: <read-only>, #key index = 0) => (result :: <read-only>);
  value + index * 8;
end method pointer-value;

define method content-size (value :: limited(<class>, subclass-of: <read-only>)) => (result :: <integer>);
  8;
end method content-size;

define constant <tni> = <integer>;

define  class <invisible-typedef> (<statically-typed-pointer>) end;

define sealed inline-only method invisible_typedef$a
    (ptr :: <invisible-typedef>) => (result :: <tni>);
  signed-long-at(ptr, offset: 0);
end method invisible_typedef$a;

define sealed inline-only method invisible_typedef$a-setter
    (value :: <tni>, ptr :: <invisible-typedef>) => (result :: <tni>);
  signed-long-at(ptr, offset: 0) := value;
  value;
end method invisible_typedef$a-setter;

define method pointer-value (value :: <invisible-typedef>, #key index = 0) => (result :: <invisible-typedef>);
  value + index * 4;
end method pointer-value;

define method content-size (value :: limited(<class>, subclass-of: <invisible-typedef>)) => (result :: <integer>);
  4;
end method content-size;

define  class <tni*> (<statically-typed-pointer>) end;

define inline method pointer-value
    (ptr :: <tni*>, #key index = 0)
 => (result :: <tni>);
  signed-long-at(ptr, offset: index * 4);
end method pointer-value;

define inline method pointer-value-setter
    (value :: <tni>, ptr :: <tni*>, #key index = 0)
 => (result :: <tni>);
  signed-long-at(ptr, offset: index * 4) := value;
  value;
end method pointer-value-setter;

define method content-size (value :: limited(<class>, subclass-of: <tni*>)) => (result :: <integer>);
  4;
end method content-size;

define  class <tni<@2>> (<tni*>, <c-vector>) end class;

define  class <array-slot> (<statically-typed-pointer>) end;

define sealed inline-only method array_slot$a
    (ptr :: <array-slot>) => (result :: <tni<@2>>);
  as(<tni<@2>>, ptr + 0);
end method array_slot$a;

define method pointer-value (value :: <array-slot>, #key index = 0) => (result :: <array-slot>);
  value + index * 8;
end method pointer-value;

define method content-size (value :: limited(<class>, subclass-of: <array-slot>)) => (result :: <integer>);
  8;
end method content-size;

