# debug = require('debug') 'record:connector:key_val'

module.exports =
class KeyVal extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    Object.defineProperty @::, 'kvPrefix',
      get: ->
        return @_kvPrefix if @hasOwnProperty '_kvPrefix'
        @_kvPrefix = @tableName
      set: (val) ->
        @_kvPrefix = val

    _key: (id, index) ->
      if index then "#{@kvPrefix}##{id}:#{index}" else "#{@kvPrefix}:#{id}"

    _keySeq: (field) ->
      "#{@kvPrefix}_#{field}_seq"
