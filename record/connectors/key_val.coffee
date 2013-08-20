flow  = require 'flow-coffee'
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

    # Can return batches with elemets count less then _options.batchSize_!
    findInBatches: ([options]..., fn, callback) ->
      options ||= {}
      from = options.start ? 1
      batch_size = options.batchSize || 1000
      max_id = 0
      do new flow
        context:  @
        error:    (err) -> callback? err
        blocks:   [
          (next) -> @maxId next
          (id_seq, next) ->
            return callback? null unless max_id = id_seq
            next()
          (next) ->
            remain = max_id - from
            return callback? null if remain < 1
            to = from + (Math.min batch_size, remain)
            ids = [from...to]
            from = to
            next.rewind()
            @getMulti ids, (err, items) ->
              return callback? err if err
              items = (item for item in items when item)
              return next() unless items.length
              fn items, (err) ->
                return callback? err if err
                next()
        ]
      @
