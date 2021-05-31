# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.

import nim_dezero/core
import nim_dezero/function
import nim_dezero/extra_ops
import neo

var
  x = initVariable(0.5)
  y = x.square.exp.square

echo y.data

y.backward()
echo x.grad
