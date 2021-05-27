import neo

proc `+`[T: SomeFloat](x: Vector[T], k: T): Vector[T] =
    let e = constantVector(x.len, k)
    return x + e
proc `+`[T: SomeFloat](k: T,x: Vector[T]): Vector[T] = x + k

proc `-`[T: SomeFloat](x: Vector[T], k: T): Vector[T] = x + (-k)

proc `-`[T: SomeFloat](k: T,x: Vector[T]): Vector[T] = k + (-x)