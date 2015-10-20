module: test

define constant anonymous-0 = find-c-function("a");
define function a
    (arg1 :: <integer>)
 => ();
  anonymous-0(arg1);
  values();
end function a;

define constant anonymous-1 = find-c-function("b");
define function b
    (c :: <integer>)
 => ();
  anonymous-1(c);
  values();
end function b;

define constant anonymous-2
  = constrain-c-function(find-c-function("d"), #(), #t, list(<integer>));
define function d
    ()
 => (result :: <integer>);
  let result-value
    = anonymous-2();
  values(result-value);
end function d;

