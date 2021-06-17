import neo
proc ones_like*[V: Vector](v: V): V = ones(v.len)
proc ones_like*[M: Matrix](m: M): M = ones(m.M, m.N)
