import neo, sugar, deques
type
  Functionable* = Vector[float] or Matrix[float]
  Variable *[T: Functionable] = ref object of RootObj
    d*: T
    grad*: T
    creator: Function[T]
  Function*[T: Functionable] = ref object
    input*, output*: Variable[T]
    f: T -> T
    b: (T, T) -> T

proc backward*[F: Function](f: var F, gy: F.T): F.T {.inline.}

## Variable Methods

proc initVariable*[T](d: T): Variable[T] {.inline.} = Variable[T](d: d)

proc data*[T](v: Variable[T]): T {.inline.} = v.d

proc set_creator*[T: Functionable](v: var Variable[T], f: var Function[T]): void =
  v.creator = f

proc backward*[T: Functionable](v: var Variable[T]): void =
  var funcs = initDeque[Function[T]]()
  funcs.addLast(v.creator)
  while funcs.len > 0:
    var
      f = funcs.popLast
      x = f.input
      y = f.output
    x.grad = f.backward(y.grad)
    if x.creator != nil:
      funcs.addLast(x.creator)

## Function's methods

proc createFunction*[T](forward: T -> T, backward: (T, T) -> T): Function[T] {.inline.} =
  Function[T](f: forward, b: backward)

proc call*[F: Function](f: var F, input: Variable[F.T]): Variable[F.T] {.inline.} =
  var
    x = input.data
    y = f.f(x)
    output = initVariable(y)
  output.set_creator(f)
  f.input = input
  f.output = output
  return output

proc backward*[F: Function](f: var F, gy: F.T): F.T {.inline.} =
  var x = f.input.data
  return f.b(x, gy)
