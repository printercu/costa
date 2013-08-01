classkit  = require 'coffee_classkit'
express   = require 'express'

# FIXME: seems to be too dirty
# Creates express application instance and mounts all Application hierarchy
# as its prototype.
module.exports = class Application extends Function
  classkit.inject @

  @includeAll module, prefix: './application',
    'initialization'

  @express: express

  constructor: ({@root} = {}) ->
    self = express()
    self.constructor = @constructor
    self.__proto__ = @__proto__
    self.root = @root
    return self
