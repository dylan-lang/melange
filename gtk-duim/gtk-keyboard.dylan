Module:       gtk-duim
Synopsis:     GTK keyboard mapping implementation
Author:       Andy Armstrong, Scott McKay
Copyright:    Original Code is Copyright (c) 1995-2004 Functional Objects, Inc.
              All rights reserved.
License:      Functional Objects Library Public License Version 1.0
Dual-license: GNU Lesser General Public License
Warranty:     Distributed WITHOUT WARRANTY OF ANY KIND

/// GTK keyboard handling

define method handle-gtk-key-event
    (sheet :: <sheet>, event :: <GdkEventKey>)
 => (handled? :: <boolean>)
  let _port = port(sheet);
  when (_port)
    let char-codepoint = gdk-keyval-to-unicode(event.GdkEventkey-keyval);
    let char = when (char-codepoint > 0) as(<character>, char-codepoint) end;
    let class = if (event.GdkEventKey-type == $GDK-KEY-PRESS)
                  <key-press-event>
                else
                  <key-release-event>
                end;
    // ---*** Some keyboard symbols don't have the expected name. Translate here.
    let keysym = as(<symbol>, gdk-keyval-name(event.GdkEventkey-keyval));
    // ---*** Yeah, modifiers are broken too.
    let modifiers = 0;
    distribute-event(_port,
		     make(class,
			  sheet:     sheet,
			  key-name:  keysym,
			  character: char,
			  modifier-state: modifiers));
    #t
  end
end method handle-gtk-key-event;

