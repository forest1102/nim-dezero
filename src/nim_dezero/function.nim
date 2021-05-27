import neo, math, sugar, options
import types


proc Exp*[T: Functionable](): Function[T] {.inline.} =
  createFunction[T](
    (x: T) => exp(x),
    (x, gy: T) => exp(x) |*| gy
  )
proc exp*[V: Variable](x: V): V =
  var f = Exp[V.T]()
  return f.call(x)

proc Square*[T: Functionable](): Function[T] {.inline.} =
  createFunction[T](
    (x: T) => x |*| x,
    (x, gy: T) => 2.0 * x |*| gy
  )

proc square*[V: Variable](x: V): V =
  var f = Square[V.T]()
  return f.call(x)
