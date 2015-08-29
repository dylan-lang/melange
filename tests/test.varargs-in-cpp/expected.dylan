module: test

define constant $TEST-SINGLE-ENTRY = 0;

define constant <test-single-t> = <C-signed-int>;

define constant $TEST-SINGLE-ENTRY-WITH-VALUE = 1;

define constant <test-single-with-value-t> = <C-signed-int>;

define constant $DISPATCH-TEST-ENUM-VALUE = 1;

define constant <test2-t> = <C-signed-int>;

define constant $DISPATCH-BLOCK-BARRIER = 1;
define constant $DISPATCH-BLOCK-DETACHED = 2;
define constant $DISPATCH-BLOCK-ASSIGN-CURRENT = 4;
define constant $DISPATCH-BLOCK-NO-QOS-CLASS = 8;
define constant $DISPATCH-BLOCK-INHERIT-QOS-CLASS = 16;
define constant $DISPATCH-BLOCK-ENFORCE-QOS-CLASS = 32;

define constant <dispatch-block-flags-t> = <C-unsigned-long>;

