``melange`` is used to generate C-FFI bindings to libraries with a C API
by parsing C header files.

``melange`` was originally part of Gwydion Dylan. It has been converted to
work with Open Dylan and ``c-ffi``.

Build
-----

Be sure that you cloned this repository recursively or have otherwise
initialized and updated the git submodules. This will not build without
the submodules present.

::

    dylan-compiler -build parsergen
    _build/bin/parsergen melange-core/c-parse.input melange-core/c-parse.dylan
    _build/bin/parsergen melange/int-parse.input melange/int-parse.dylan
    dylan-compiler -build melange

You should be using Open Dylan 2012.1 or later.

Usage
-----

The documentation for this tool is available at http://opendylan.org/documentation/melange/.
