# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import nim_dezero

suite "Test Varibles.nim":
  test "can init int variable":
    var v = initVariable[int](1)
    check v.data == 1

  test "can init Vector varible":
    var
      vec = randomVector(5, 3.5)
      v = initVariable(vec)
    check v.data == vec


