module: test

define constant <anonymous-0> = limited(<integer>, min: 0, max: 0);
define constant $test-enum-element-1 :: <anonymous-0> = 0;

define constant <typedefed-enum> = limited(<integer>, min: 0, max: 0);
define constant $test-typedefed-enum-element-1 :: <typedefed-enum> = 0;

define constant <anonymous-2> = limited(<integer>, min: 0, max: 1);
define constant $multiple-elements-1 :: <anonymous-2> = 0;
define constant $multiple-elements-2 :: <anonymous-2> = 1;

define constant <mv-enum> = limited(<integer>, min: 1, max: 4);
define constant $multiple-valued-elements-1 :: <mv-enum> = 1;
define constant $multiple-valued-elements-2 :: <mv-enum> = 3;
define constant $multiple-valued-elements-3 :: <mv-enum> = 4;

define constant <anonymous-4> = limited(<integer>, min: 0, max: 2);
define constant $include-this-value :: <anonymous-4> = 0;
define constant $also-include-this-value :: <anonymous-4> = 2;

define constant <anonymous-5> = limited(<integer>, min: 0, max: 0);
define constant $trailing-comma :: <anonymous-5> = 0;

define constant <anonymous-6> = limited(<integer>, min: 3, max: 3);
define constant $trailing-comma-with-value :: <anonymous-6> = 3;

