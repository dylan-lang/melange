module: test

define constant anonymous-2
  = constrain-c-function(find-c-function("included"), #(), #t, list(<integer>));
define function included
    ()
 => (result :: <integer>);
  let result-value
    = anonymous-2();
  values(result-value);
end function included;

