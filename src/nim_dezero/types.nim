import neo, sugar, deques, options
type
  Functionable* = Vector[float] or Matrix[float]
  Variable *[T: Functionable] = ref object of RootObj
    d: T
    grad*: T
    creator: Function[T]
  Function*[T: Functionable] = ref object
    input, output: Variable[T]
    f: T -> T
    b: (T, T) -> T

proc backward*[F: Function](f: var F, gy: F.T): F.T {.inline.}

## Variable Methods

proc initVariable*(d: float, grad: float = 1.0): auto {.inline.} = 
  Variable[Vector[float]](d: constantVector(1, d), grad: constantVector(1, grad))

proc initVariable*[T: Vector[float]](d: T, grad:Option[T] = none(T)): Variable[T] {.inline.} = 
  if grad.isSome:
    checkDim d.len == grad.get.len 
    return Variable[T](d: d, grad: grad.get)
  else:
    return Variable[T](d: d, grad: ones(d.len))

proc initVariable*[T: Matrix[float]](d: T, grad:Option[T] = none(T)): Variable[T] {.inline.} = 
  if grad.isSome:
    checkDim d.M == grad.get.M and d.N == grad.get.N
    return Variable[T](d: d, grad: grad.get)
  else:
    return Variable[T](d: d, grad: ones(d.M, d.N))

proc data*[V: Variable](v: V): V.T {.inline.} = v.d

proc set_creator*[V: Variable](v: var V, f: var Function[V.T]): void =
  v.creator = f

proc backward*[V: Variable](v: var V): void =
  var funcs = initDeque[Function[V.T]]()
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

proc createFunction*[T: Functionable](forward: T -> T, backward: (T, T) ->
    T): Function[T] {.inline.} =
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
