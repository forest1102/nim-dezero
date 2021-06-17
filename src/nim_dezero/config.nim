type Configuration = object
    enable_backprop*: bool
var configuration* = Configuration(enable_backprop: true)

template no_grad*(body: untyped) =
    var old = configuration
    configuration.enable_backprop = false
    body
    configuration = old

