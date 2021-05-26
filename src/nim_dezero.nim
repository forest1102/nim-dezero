# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.

include nim_dezero/function
include neo

var
  A = Square[Vector[float]]()
  B = Exp[Vector[float]]()
  C = Square[Vector[float]]()
  x = initVariable[Vector[float]](constantVector(1, 0.5))
  a = A.call(x)
  b = B.call(a)
  y = C.call(b)

echo y.data

y.grad = constantVector(1, 1.0)
y.backward()
echo x.grad
