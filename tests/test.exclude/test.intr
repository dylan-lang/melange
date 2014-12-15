module: test

define interface
  #include "exclude.h",
    exclude: {
      "excluded",
      "struct excluded_struct"
    };
end interface;
