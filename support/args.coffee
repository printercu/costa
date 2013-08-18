module.exports =
  # Returns _[options, [other_args]]_. Options are taken from first or last
  # element if it's object. Last element is prefered. If they are not objects
  # _{}_ is returned in place of _options_.
  #
  #   fn = -> Args.findOptions arguments
  #
  #   fn param, opt: 'val'
  #   # => [{opt: 'val'}, [param]]
  #   fn opt: 'val', ->
  #   # => [{opt: 'val'}, [function]]
  #
  # Supports one argument as array or arguments object
  findOptions: (args) ->
    return [{}, []] unless args?.length
    last_id = args.length - 1
    if typeof (last = args[last_id]) is 'object'
      [last, Array::slice.call(args, 0, last_id)]
    else if typeof args[0] is 'object'
      [args[0], Array::slice.call(args, 1)]
    else
      [{}, Array::slice.call args]
