import neo, sugar, options, sequtils, binaryheap, sets, hashes
import utils, config
type
  Functionable* = Vector[float] or Matrix[float]
  Variable *[T: Functionable] = ref object of RootObj
    d: T
    grad*: Option[T]
    name: Option[string]
    generation: int
    creator: Function[T]
  Function*[T: Functionable] = ref object of RootObj
    inputs, outputs: seq[Variable[T]]
    generation: int
    f: seq[T] -> seq[T]
    b: (seq[T], seq[T]) -> seq[T]

proc backward*[F: Function](f: var F, gy: seq[F.T]): seq[F.T] {.inline.}

## Variable Methods

proc initVariable*(d: float, name = none(string)): auto {.inline.} =
  Variable[Vector[float]](d: constantVector(1, d), generation: 0, name: name)

proc initVariable*[T: Functionable](d: T, name = none(string)): Variable[
    T] {.inline.} =
  Variable[T](d: d, generation: 0, name: name)

proc data*[V: Variable](v: V): V.T {.inline.} = v.d

proc set_creator*[V: Variable](v: var V, f: var Function[V.T]): void =
  v.creator = f
  v.generation = f.generation + 1

proc hash*[F: Function](x: F): Hash =
  result = hash(x.generation)
  result = result !& hash(x.b)
  result = !$result

proc backward*[V: Variable](v: var V, retain_grad = false): void =
  if v.grad.isNone:
    v.grad = ones_like(v.data).some


  var
    funcs = newHeap[Function[V.T]]((x, y: Function[V.T]) => y.generation - x.generation)
    seen_set = [v.creator].toHashSet()
  funcs.push(v.creator)
  while funcs.size > 0:
    var
      f = funcs.pop
      gys = collect(newSeq):
        for output in f.outputs:
          output.grad.get
      gxs = f.backward(gys)
    for i in 0..<min(f.inputs.len, gxs.len):
      var x: V
      shallowCopy(x, f.inputs[i])
      if x.grad.isNone:
        x.grad = gxs[i].some
      else:
        x.grad = (x.grad.get + gxs[i]).some
      if not x.creator.isNil and x.creator notin seen_set:
        funcs.push(x.creator)
        seen_set.incl(x.creator)
    if not retain_grad:
      for y in f.outputs:
        y.grad = none(V.T)

proc cleargrad*[V: Variable](v: var V): void =
  v.grad = none(V.T)

## Function's methods

proc createFunction*[T: Functionable](
  forward: seq[T] -> seq[T],
  backward: (seq[T], seq[T]) -> seq[T]): Function[T] {.inline.} =
  Function[T](f: forward, b: backward)

proc createFunction*[T: Functionable](
  forward: seq[T] -> T,
  backward: (seq[T], seq[T]) -> seq[T]): Function[T] {.inline.} =
  Function[T](f: (xs: seq[T]) => @[forward(xs)], b: backward)
proc createFunction*[T: Functionable](
  forward: seq[T] -> T,
  backward: (seq[T], seq[T]) -> T): Function[T] {.inline.} =
  Function[T](f: (xs: seq[T]) => @[forward(xs)], b: (xs, gys: seq[T]) => @[
      backward(xs, gys)])

proc call*[F: Function](f: var F, inputs: varargs[Variable[F.T]]): seq[Variable[
    F.T]] {.inline.} =
  var
    xs = collect(newSeq):
      for x in inputs:
        x.data
    ys = f.f(xs)
    outputs = collect(newSeq):
      for y in ys:
        initVariable(y)
  if configuration.enable_backprop:
    f.generation = inputs.mapIt(it.generation).max
    for output in outputs.mitems:
      output.set_creator(f)
    f.inputs = toSeq(inputs)
    f.outputs = outputs
  return outputs

proc backward*[F: Function](f: var F, gy: seq[F.T]): seq[F.T] {.inline.} =
  var xs = collect(newSeq):
    for input in f.inputs:
      input.data
  return f.b(xs, gy)
