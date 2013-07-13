lingo     = require 'lingo'

module.exports =
class  extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    Object.defineProperty @::, 'tableName',
      get: ->
        return @_tableName if @hasOwnProperty '_tableName'
        @_tableName =
          if !@__supper__?.constructor || @__supper__?.constructor.name is 'Record'
            lingo.underscore @name
          else
            @__supper__.constructor.tableName
      set: (val) -> @_tableName = val
