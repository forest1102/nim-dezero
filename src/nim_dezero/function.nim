import neo, math, sugar, options
import types


proc Exp*[T: Functionable](): Function[T] {.inline.} =
  createFunction[T](
    (x: T) => exp(x),
    (x, gy: T) => exp(x) |*| gy
  )

proc Square*[T: Functionable](): Function[T] {.inline.} =
  createFunction[T](
    (x: T) => x |*| x,
    (x, gy: T) => 2.0 * x |*| gy
  )
