Module:    gtk-hello-world
Synopsis:  Hello World in GTK2
Author:    Andreas Bogk, Hannes Mehnert
Copyright: (c) 2007 Dylan Hackers

define C-function g-type-from-instance
  input parameter instance :: <_GTypeInstance>;
  result type :: <GType>;
  c-name: "g_type_from_instance";
end;

define method make(type :: subclass(<GTypeInstance>), #rest args, 
                   #key address, #all-keys)
 => (result :: <GTypeInstance>)
  if(address & (as(<integer>, address) ~= 0))
    let instance = next-method(<GTypeInstance>, address: address);
    let g-type = g-type-from-instance(instance);
    let dylan-type = find-gtype(g-type);
    next-method(dylan-type, address: address);
  else
    next-method();
  end if;
end method make;

define function all-subclasses(x :: <class>)
  => (subclasses :: <collection>)
  apply(concatenate, x.direct-subclasses, 
        map(all-subclasses, x.direct-subclasses))
end;

define function find-gtype-by-name(name :: <string>)
  block(return)
    for(i in $all-gtype-instances)
      if(as-uppercase(i.debug-name) = as-uppercase(concatenate("<_", name, ">")))
        return(i)
      end if;
    finally
      error("Unknown GType %= encountered.", name)
    end for;
  end block;
end function find-gtype-by-name;

define method find-gtype(g-type :: <integer>)
 => (type :: <class>);
  let dylan-type = element($gtype-table, g-type, default: #f);
  unless(dylan-type)
    let type-name = g-type-name(g-type);
    dylan-type := find-gtype-by-name(type-name);
    $gtype-table[g-type] := dylan-type;
  end unless;
  dylan-type
end method find-gtype;

define constant $gtype-table = make(<table>);

define constant $all-gtype-instances = all-subclasses(<_GTypeInstance>);

define function initialize-gtk
    () => ()
  let name = application-name();
  with-c-string (string = name)
    let string* = make(<C-string*>, element-count: 1);
    string*[0] := string;
    let string** = make(<char***>);
    string**[0] := string*;
    let int* = make(<C-int*>);
    int*[0] := 1;
    %gtk-init(int*, string**);
    destroy(string*);
    destroy(string**);
    destroy(int*)
  end
end function initialize-gtk;

define method main () => ()
  format-out("Hello, world!\n");

  initialize-gtk();
  let window = gtk-window-new($GTK-WINDOW-TOPLEVEL);
  let label = gtk-label-new("Hello, world!");
  gtk-container-add(window, label);
  gtk-widget-show(label);
  gtk-widget-show(window);
  gtk-main();
end method main;

begin
  main();
end;
