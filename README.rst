This is a port to Open Dylan of the ``melange`` tool from Gwydion Dylan.

``melange`` is used to generate C-FFI bindings to libraries with a C API
by parsing C header files.

Build
-----

Be sure that you cloned this repository recursively or have otherwise
initialized and updated the git submodules. This will not build without
the submodules present.

::

    dylan-compiler -build parsergen
    _build/bin/parsergen melange-parser/c-parse.input melange-parser/c-parse.dylan
    _build/bin/parsergen melange/int-parse.input melange/int-parse.dylan
    dylan-compiler -build melange

You should be using a pre-release build of Open Dylan 2012.1 from
October 15, 2012 or later.

Usage
-----

The documentation for this tool will be ported in the future.

