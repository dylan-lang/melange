Module:    dylan-user
Synopsis:  Hello World in GTK2
Author:    Andreas Bogk, Hannes Mehnert
Copyright: (c) 2007 Dylan Hackers

define library gtk-hello-world
  use common-dylan;
  use dylan;
  use io;
  use system;
  use c-ffi;
  use gtk-c-ffi;
end library gtk-hello-world;
