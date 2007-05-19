Module:    gtk-hello-world
Synopsis:  Hello World in GTK2
Author:    Andreas Bogk, Hannes Mehnert
Copyright: (c) 2007 Dylan Hackers

define method main () => ()
  format-out("Hello, world!\n");

  initialize-gtk();
  let window = gtk-window-new($GTK-WINDOW-TOPLEVEL);
  let button = gtk-button-new-with-label("Hello, world!");
  gtk-container-add(window, button);
  g-signal-connect(button, "clicked", method(#rest args) button.@label := format-to-string("Hello world! %=\n", args) end);
  gtk-widget-show(button);
  gtk-widget-show(window);
  gtk-main();
end method main;

begin
  main();
end;

