import neo, math, sugar, options
import core


proc Exp*[T: Functionable](): Function[T] {.inline.} =
  createFunction[T](
    (x: seq[T]) => exp(x[0]),
    (x, gy: seq[T]) => exp(x[0]) |*| gy[0]
  )
proc exp*[V: Variable](x: V): V =
  var f = Exp[V.T]()
  return f.call(x)[0]

proc Square*[T: Functionable](): Function[T] {.inline.} =
  createFunction[T](
    (x: seq[T]) => x[0] |*| x[0],
    (x, gy: seq[T]) => 2.0 * x[0] |*| gy[0]
  )

proc square*[V: Variable](x: V): V =
  var f = Square[V.T]()
  return f.call(x)[0]

proc Add*[T: Functionable](): Function[T] {.inline.} =
  createFunction[T](
    (xs: seq[T]) => xs[0] + xs[1],
    (xs, gy: seq[T]) => @[gy[0], gy[0]]
  )

proc add*[V: Variable](x0, x1: V): V =
  var f = Add[V.T]()
  return f.call(x0, x1)[0]
