#! /bin/bash

TARGET=c-ffi
if [[ $# -ge 1 ]]
then
  TARGET=$1
fi
TESTS=test.*
if [[ $# -ge 2 ]]
then
  shift
  TESTS=$*
fi

for directory in $TESTS; do
    [ -d "${directory}" ] || continue
    input="${directory}/test.intr"
    expected="${directory}/expected-${TARGET}.dylan"
    actual="${directory}/actual-${TARGET}.dylan"

    if [ ! -f "$input" ]; then
      printf "Test skipped: Input file %s is missing.\n" "$input"
      continue
    fi
    if [ ! -f "$expected" ]; then
      printf "Test skipped: Expected output file %s is missing.\n" "$expected"
      continue
    fi

    ../_build/bin/melange -I${directory} -T${TARGET} $input $actual

    diff -u $expected $actual
    result=$?
    rm $actual;

    if [ $result != 0 ]; then
      printf "Test failed: %s\n" "${directory}";
      exit 1;
    else
      printf "Test OK: %s\n" "${directory}";
    fi
done

exit 0
