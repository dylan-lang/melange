module: test

define interface
  #include "seal-functions.h";

  struct "struct sealed",
    seal-functions: sealed;
  struct "struct open",
    seal-functions: open;
end interface;
