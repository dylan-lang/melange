module: test

define interface
  #include "inline-functions.h",
   inline-functions: inline-only;

  function "b",
    inline: not-inline;
end interface;
