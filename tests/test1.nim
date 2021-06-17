# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest, options

import neo
include nim_dezero/core
include nim_dezero/function
include nim_dezero/extra_ops

proc numerical_diff [F: Function](f: var F, x: Variable[F.T], eps = 1e4): F.T =
  var
    x0 = initVariable(x.data - eps)
    x1 = initVariable(x.data + eps)
    y0 = f.call(x0)[0]
    y1 = f.call(x1)[0]
  return (y1.data - y0.data) / (2 * eps)

suite "Test Variable":
  test "initialize 1D vector":
    var x = initVariable(2.0)
    check x.data == constantVector(1, 2.0)
  test "initialize 2D vector":
    var x = initVariable(constantVector(2, 2.0))
    check x.data == constantVector(2, 2.0)
  test "initialize Matrix":
    var x = initVariable(constantMatrix(2, 3, 2.0))
    check x.data == constantMatrix(2, 3, 2.0)



suite "Test Square Func":
  test "forward":
    var
      x = initVariable(2.0)
      y = square(x)
      expected = constantVector(1, 4.0)
    check y.data =~ expected

  test "test backward":
    var
      x = initVariable(3.0)
      y = square(x)
    y.backward()

    var
      f = Square[Vector[float]]()
      expected = numerical_diff(f, x)
    check x.grad.get =~ expected


