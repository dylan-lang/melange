module: test

define constant <anonymous-0> = limited(<integer>, min: 0, max: 0);
define constant $test-enum-element-1 :: <anonymous-0> = 0;

define constant <typedefed-enum> = limited(<integer>, min: 0, max: 0);
define constant $test-typedefed-enum-element-1 :: <typedefed-enum> = 0;

define constant <anonymous-2> = limited(<integer>, min: 0, max: 1);
define constant $multiple-elements-1 :: <anonymous-2> = 0;
define constant $multiple-elements-2 :: <anonymous-2> = 1;

define constant <anonymous-3> = limited(<integer>, min: 1, max: 4);
define constant $multiple-valued-elements-1 :: <anonymous-3> = 1;
define constant $multiple-valued-elements-2 :: <anonymous-3> = 3;
define constant $multiple-valued-elements-3 :: <anonymous-3> = 4;

define constant <anonymous-4> = limited(<integer>, min: 0, max: 0);
define constant $deprecated-excluded-value :: <anonymous-4> = 0;

define constant <anonymous-5> = limited(<integer>, min: 0, max: 2);
define constant $include-this-value :: <anonymous-5> = 0;
define constant $no-no-no-not-this-value :: <anonymous-5> = 1;
define constant $also-include-this-value :: <anonymous-5> = 2;

define constant <anonymous-6> = limited(<integer>, min: 0, max: 0);
define constant $trailing-comma :: <anonymous-6> = 0;

define constant <anonymous-7> = limited(<integer>, min: 3, max: 3);
define constant $trailing-comma-with-value :: <anonymous-7> = 3;

