module: c-declarations

define class <debug-back-end> (<back-end>)
end;

define method make-backend-for-target (target == #"debug", stream :: <stream>)
  make(<debug-back-end>, stream: stream)
end;

define method write-declaration (decl :: <declaration>, back-end :: <debug-back-end>)
 => ();
end;

