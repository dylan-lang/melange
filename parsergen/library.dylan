module: dylan-user
copyright: See LICENSE file in this distribution.

define library parsergen
  use common-dylan;
  use dylan;
  use io;
  use system;
end library parsergen;

define module lisp-read
  use common-dylan, exclude: { format-to-string };
  use dylan-extensions;
  use streams;
  use print;
  use standard-io;
  export
    <token>, <identifier>, <string-literal>, <character-literal>,
    <keyword>, <macro-thingy>, <lparen>, $lparen,
    <rparen>, $rparen, <list-start>, $list-start,
    lex, peek-lex, lisp-read;
end module lisp-read;

define module parsergen
  use common-dylan, exclude: { format-to-string };
  use dylan-extensions;
  use streams;
  use print;
  use format;
  use standard-io;
  use file-system;
  use lisp-read, import: { lisp-read };
end module parsergen;
