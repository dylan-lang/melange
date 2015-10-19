enum {
  test_enum_element_1
};

typedef enum {
  test_typedefed_enum_element_1
} typedefed_enum;

enum {
  multiple_elements_1,
  multiple_elements_2
};

enum mv_enum {
  multiple_valued_elements_1 = 1,
  multiple_valued_elements_2 = 3,
  multiple_valued_elements_3
};

enum {
  deprecated_excluded_value
};

enum {
  include_this_value,
  no_no_no_not_this_value,
  also_include_this_value
};

enum {
  trailing_comma,
};

enum {
  trailing_comma_with_value = 0x3,
};

