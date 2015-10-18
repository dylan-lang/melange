module: test

define constant anonymous-3 = find-c-function("a");
define function a
    (arg1 :: <integer>)
 => ();
  anonymous-3(arg1);
  values();
end function a;

define constant anonymous-4 = find-c-function("b");
define function b
    (arg1 :: <integer>)
 => ();
  anonymous-4(arg1);
  values();
end function b;

define constant anonymous-5
  = constrain-c-function(find-c-function("d"), #(), #t, list(<integer>));
define function d
    ()
 => (result :: <integer>);
  let result-value
    = anonymous-5();
  values(result-value);
end function d;

