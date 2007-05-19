Module:    dylan-user
Author:    Hannes Mehnert, Andreas Bogk
Copyright: (C) 2007,.  All rights reserved.

define module gtk-support
  use common-dylan;
  use c-ffi;
  use gtk-internal, export: all;
  use finalization;
  use dylan-primitives;
  use dylan-extensions, import: { debug-name, integer-as-raw, raw-as-integer };

  export g-signal-connect, initialize-gtk,
    gtk-widget-get-window,
    gtk-widget-get-state,
    property-getter-definer,
    property-setter-definer;
end;  
