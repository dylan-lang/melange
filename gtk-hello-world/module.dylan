Module:    dylan-user
Synopsis:  Hello World in GTK2
Author:    Andreas Bogk, Hannes Mehnert
Copyright: (c) 2007 Dylan Hackers

define module gtk-hello-world
  use common-dylan;
  use threads;
  use format-out;
  use streams;
  use c-ffi;
  use dylan-extensions, import: { debug-name };
  use gtk-internal;
end module gtk-hello-world;
