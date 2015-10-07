#! /bin/bash

for directory in test.*; do
    [ -d "${directory}" ] || continue
    input="${directory}/test.intr"
    expected_c_ffi="${directory}/expected-c-ffi.dylan"
    actual_c_ffi="${directory}/actual-c-ffi.dylan"

    if [ ! -f "$input" ]; then
      printf "Input file %s is missing.\n" "$input"
      exit 1;
    fi
    if [ ! -f "$expected_c_ffi" ]; then
      printf "Expected output file %s is missing.\n" "$expected_c_ffi"
      exit 1;
    fi

    ../_build/bin/melange -I${directory} -Tc-ffi $input $actual_c_ffi

    diff -u $expected_c_ffi $actual_c_ffi

    if [ $? != 0 ]; then
      printf "Test failed: %s\n" "${directory}";
      rm $actual_c_ffi;
      exit 1;
    else
      printf "Test OK: %s\n" "${directory}";
      rm $actual_c_ffi;
    fi
done

exit 0
