typedef int (*old_style_syntax_cb)(void *payload);
int old_style_syntax(old_style_syntax_cb callback);

typedef void new_style_syntax_cb(void *payload);
int new_style_syntax(new_style_syntax_cb *callback);

int anonymous_non_typedef_function_pointer(int (*)(void *payload));
int non_typedef_function_pointer(int (*old)(void *payload));
