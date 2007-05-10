Module:    gtk-hello-world
Synopsis:  Hello World in GTK2
Author:    Andreas Bogk, Hannes Mehnert
Copyright: (c) 2007 Dylan Hackers

define C-function g-type-from-instance
  input parameter instance :: <GTypeInstance>;
  result type :: <GType>;
  c-name: "g_type_from_instance";
end;

define C-function g-value-type
  input parameter instance :: <GValue>;
  result type :: <GType>;
  c-name: "g_value_type";
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
      error("Unknown GType %= encountered.", as(<byte-string>, name))
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

define constant $all-gtype-instances = all-subclasses(<_GTypeInstance>);

define function dylan-meta-marshaller (closure :: <GClosure>,
                                       return-value :: <GValue>,
                                       n-param-values :: <integer>,
                                       param-values :: <GValue>,
                                       invocation-hint :: <gpointer>,
                                       marshal-data :: <gpointer>)
  let values = #();
  for(i from 0 below n-param-values)

//    let address = integer-as-raw(param-values.raw-pointer-address.raw-as-integer + i * sizeof-gvalue());
//    let value* = make(<GValue>, address: address);

    let value = make-c-pointer(<GValue>,
                               primitive-machine-word-add
                                 (primitive-cast-pointer-as-raw
                                   (primitive-unwrap-c-pointer(param-values)),
                                  integer-as-raw
                                    (i * sizeof-gvalue())),
                               #[]);
    values := pair(g-value-to-dylan(value), values);
//    value*;
  end for;
  values := reverse!(values);
  let res = apply(import-c-dylan-object(c-type-cast(<C-dylan-object>, marshal-data)), values);
  if(return-value ~= null-pointer(<gvalue>))
    select(g-value-type(return-value))
      $G-TYPE-BOOLEAN => g-value-set-boolean(return-value, 
                                             if(res) 1 else 0 end);
      otherwise error("Unsupported GType in return from signal handler.");
    end select;
  end if;
end;


define C-callable-wrapper _dylan-meta-marshaller of dylan-meta-marshaller
  parameter closure         :: <GClosure>;
  parameter return-value    :: <GValue>;
  parameter n-param-values  :: <guint>;
  parameter param-values    :: <GValue>;
  parameter invocation-hint :: <gpointer>;
  parameter marshal-data    :: <gpointer>;
  c-name: "foo";
end;

define C-function sizeof-gvalue
  result size :: <C-int>;
  c-name: "sizeof_gvalue";
end;

define C-function sizeof-gclosure
  result size :: <C-int>;
  c-name: "sizeof_gclosure";
end;



define function g-signal-connect(instance :: <GObject>, 
                                 signal :: <string>,
                                 function :: <function>,
                                 #key run-after? :: <boolean>)
  register-c-dylan-object(function);
  let closure = g-closure-new-simple(sizeof-gclosure(),
                                     null-pointer(<gpointer>));
  g-closure-set-meta-marshal
    (closure, export-c-dylan-object(function), _dylan-meta-marshaller);
  g-signal-connect-closure(instance, 
                           signal, 
                           closure,
                           if(run-after?) 1 else 0 end)
end function g-signal-connect;

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


g-type-init();
// map GTK type IDs to Dylan classes
define table $gtype-table = {
                             $G-TYPE-CHAR         => <gchar>,
                             $G-TYPE-UCHAR        => <guchar>,
                             $G-TYPE-INT          => <gint>,
                             $G-TYPE-UINT         => <guint>,
                             $G-TYPE-LONG         => <glong>,
                             $G-TYPE-ULONG        => <gulong>,
                             $G-TYPE-INT64        => <gint64>,
                             $G-TYPE-UINT64       => <guint64>,
                             $G-TYPE-FLOAT        => <gfloat>,
                             $G-TYPE-DOUBLE       => <gdouble>,
                             $G-TYPE-STRING       => <gstring>,
                             $G-TYPE-POINTER      => <gpointer>,
                             gdk-event-get-type() => <GdkEvent> 
                             };

define function g-value-to-dylan(instance :: <GValue>)
 => (dylan-instance);
  let g-type = g-value-type(instance);
  if(g-type ~= $G-TYPE-INVALID)
    let dylan-type = find-gtype(g-type);
    if(subtype?(dylan-type, <C-void*>))
      make(dylan-type, address: instance.g-value-peek-pointer.pointer-address)
    else
      select(g-type)
        $G-TYPE-NONE    => #f;
        $G-TYPE-CHAR    => g-value-get-char(instance);
        $G-TYPE-UCHAR   => g-value-get-uchar(instance);
        $G-TYPE-BOOLEAN => (g-value-get-boolean(instance) = 1);
        $G-TYPE-INT     => g-value-get-int(instance);
        $G-TYPE-UINT    => g-value-get-uint(instance);
        $G-TYPE-LONG    => g-value-get-long(instance);
        $G-TYPE-ULONG   => g-value-get-ulong(instance);
        $G-TYPE-INT64   => g-value-get-int64(instance);
        $G-TYPE-UINT64  => g-value-get-uint64(instance);
        $G-TYPE-ENUM    => signal("Can't handle $G-TYPE-ENUM yet.");
        $G-TYPE-FLAGS   => signal("Can't handle $G-TYPE-FLAGS yet.");
        $G-TYPE-FLOAT   => g-value-get-float(instance);
        $G-TYPE-DOUBLE  => g-value-get-double(instance);
        $G-TYPE-STRING  => g-value-get-string(instance);
        $G-TYPE-POINTER => g-value-get-pointer(instance);
        $G-TYPE-BOXED   => #f;
        $G-TYPE-PARAM   => #f;
        $G-TYPE-OBJECT  => #f;
      end select;
    end if;
  end if;
end function g-value-to-dylan;


define function some-signal-handler (widget :: <GtkWidget>)
  format-out("signal called\n");
end;



define C-callable-wrapper _some-signal-handler of some-signal-handler
  parameter widget :: <GtkWidget>;
  c-name: "_some_signal_handler";
end;


define method main () => ()
  format-out("Hello, world!\n");

  initialize-gtk();
  let window = gtk-window-new($GTK-WINDOW-TOPLEVEL);
  let button = gtk-button-new-with-label("Hello, world!");
  gtk-container-add(window, button);
  g-signal-connect(button, "key-press-event", method(#rest args) format-out("Hello world! %=\n", args) end);
  gtk-widget-show(button);
  gtk-widget-show(window);
  gtk-main();
end method main;

begin
  main();
end;

