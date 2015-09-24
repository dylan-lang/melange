module: test

define interface
  #include "enum.h",
    exclude: {
      "deprecated_excluded_value",
      "no_no_no_not_this_value"
    };
end interface;
