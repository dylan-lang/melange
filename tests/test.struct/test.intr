module: test

define interface
  #include "struct.h";

  struct "struct a";

  struct "struct b" => <c-b>,
    name-mapper: minimal-name-mapping,
    prefix: "b-";

  struct "struct read_only",
    read-only: #t;
end interface;
