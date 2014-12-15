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

Tests
-----

Tests can be run via ``make check`` or just running ``run.sh`` within the
``tests`` directory.

Adding new tests is done by:

* Create a new directory within ``tests`` whose name starts with ``test.``.
  Directories that are not named appropriately won't be found by the
  test runner.
* Within the new test directory, create ``test.intr`` which includes a C
  header file and defines an interface appropriate to test the desired
  features.
* Within the new test directory, create ``expected.dylan`` which contains
  the Dylan that ``melange`` should generate from the ``test.intr``.

You should avoid any platform-specific dependencies as much as possible
within tests as the test runner assumes that all platforms will generate
identical output.

See the existing tests for examples.
