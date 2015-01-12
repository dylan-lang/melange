Struct and Union Clauses
========================

"Struct clauses" and "union clauses" (referred to
collectively as "container clauses") are used to specify naming
in inclusion of class slots in exactly the same way that the
options in the file clause control the handling of global
definitions. Like the function clauses described above, they
consist of the reserved word ``struct`` or ``union``, a string which
gives the full C name of the container declaration, an optional
renaming, and a list of options. If we have a structure defined by

.. code-block:: c

    typedef struct cons {
       int index;
       struct object *head;
       struct cons *tail;
    } cons_cell;

we could use the following interface definition:

.. code-block:: dylan

    define interface
       #include "cons.h";
       struct "struct cons" => <c-list>,
          superclasses: {<sequence>},
          prefix: "c-list-",
          name-mapper: identity-name-mapping,
          exclude: {"index"};
    end interface;

Valid options for container clauses include: ``import:``,
``prefix:``, ``exclude:``, ``rename:``, ``seal-functions:``,
``inline-functions:``, ``read-only:``, ``equate:``, and ``map:``.
These options act like the equivalent options which may be specified
in a file clause, but they apply to the slots of a single "class"
rather than to globally defined objects. Options specified within a
container clause override any global defaults that might have
been specified in the ``#include`` clause.  Container clauses
also permit the ``superclasses:`` option described in
:ref:`melange-class-inheritance`.

Although the recommended method for specifying a container type is to
use the full C name (i.e. ``struct foo``), you may also use an alias
defined by a typedef. Thus, in the above example, you could have specified
either ``struct cons`` or ``cons_cell``, with identical results.
