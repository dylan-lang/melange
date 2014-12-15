#! /bin/bash

for directory in test.*; do
    [ -d "${directory}" ] || continue
    input="${directory}/test.intr"
    expected="${directory}/expected.dylan"
    actual="${directory}/actual.dylan"

    if [ ! -f "$input" ]; then
      printf "Input file %s is missing.\n" "$input"
      exit 1;
    fi
    if [ ! -f "$expected" ]; then
      printf "Expected output file %s is missing.\n" "$expected"
      exit 1;
    fi

    ../_build/bin/melange -I${directory} -Tc-ffi $input $actual

    diff -u $expected $actual

    if [ $? != 0 ]; then
      printf "Test failed: %s\n" "${directory}";
      rm $actual;
      exit 1;
    else
      printf "Test OK: %s\n" "${directory}";
      rm $actual;
    fi
done

exit 0
