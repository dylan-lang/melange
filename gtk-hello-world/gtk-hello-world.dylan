Module:    gtk-hello-world
Synopsis:  Hello World in GTK2
Author:    Andreas Bogk, Hannes Mehnert
Copyright: (c) 2007 Dylan Hackers

define C-pointer-type <C-string**> => <C-string*>;

define constant <gulong> = <C-unsigned-long>;
define constant <GType> = <gulong>;

define C-function g-type-name
  input parameter g-type :: <GType>;
  result name :: <C-string>;
  c-name: "g_type_name";
end;

define C-function g-type-from-instance
  input parameter instance :: <GTypeInstance>;
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
      if(as-uppercase(i.debug-name) = as-uppercase(concatenate("<", name, ">")))
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

define constant <GtkWindowType> = limited(<integer>, min: 0, max: 1);
define constant $GTK-WINDOW-TOPLEVEL :: <GtkWindowType> = 0;
define constant $GTK-WINDOW-POPUP :: <GtkWindowType> = 1;

define C-subtype <GTypeInstance> (<C-void*>) end;
define C-subtype <GObject> (<GTypeInstance>) end;
define C-subtype <GtkWidget> (<GObject>) end;
define C-subtype <GtkContainer> (<GtkWidget>) end;
define C-subtype <GtkWindow> (<GtkContainer>) end;
define C-subtype <GtkLabel> (<GtkWidget>) end;


define constant $all-gtype-instances = all-subclasses(<GTypeInstance>);

define C-function gtk-init
  input parameter argc :: <C-int*>;
  input parameter argv :: <C-string**>;
  c-name: "gtk_init";
end;

define C-function gtk-window-new
  input parameter window-type :: <C-int>;
  result window :: <GtkWidget>;
  c-name: "gtk_window_new";
end;

define C-function gtk-label-new
  input parameter string :: <C-string>;
  result label :: <GtkLabel>;
  c-name: "gtk_label_new";
end;

define C-function gtk-widget-show
  input parameter widget :: <GtkWidget>;
  c-name: "gtk_widget_show";
end;

define C-function gtk-container-add
  input parameter container :: <GtkContainer>;
  input parameter widget :: <GtkWidget>;
  c-name: "gtk_container_add";
end;

define function initialize-gtk
    () => ()
  let name = application-name();
  with-c-string (string = name)
    let string* = make(<C-string*>, element-count: 1);
    string*[0] := string;
    let string** = make(<C-string**>);
    string**[0] := string*;
    let int* = make(<C-int*>);
    int*[0] := 1;
    gtk-init(int*, string**);
    destroy(string*);
    destroy(string**);
    destroy(int*)
  end
end function initialize-gtk;

define C-function gtk-main
  c-name: "gtk_main";
end;

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
