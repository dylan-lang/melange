module: test

define interface
  #include "struct.pointer-type-name.h";

  struct "struct a",
    pointer-type-name: <a*>;

  struct "struct b" => <c-b>,
    name-mapper: minimal-name-mapping,
    prefix: "b-",
    pointer-type-name: <yep>;

  struct "struct read_only",
    read-only: #t;
end interface;
