module: c-declarations
copyright: See LICENSE file in this distribution.

define class <mindy-back-end> (<back-end>)
end;

define method make-backend-for-target (target == #"mindy", stream :: <stream>)
  make(<mindy-back-end>, stream: stream)
end;

define method write-declaration (decl :: <declaration>, back-end :: <mindy-back-end>)
 => ();
  format(back-end.stream, " /* Ignoring declaration for %= %=*/\n", decl, decl.dylan-name)
end;
