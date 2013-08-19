util      = require 'util'

module.exports =
class Record extends require('coffee_classkit').Module
  @extendsWithProto()

  @includeAll module, prefix: './',
    'attributes'

    'model_schema'
    'storage'

    'callbacks'
    'validations'
    'persisted_validations'

  @exportAttrs 'id'
  @exportAttrs for: 'api',
    'errors'
    '_isPersisted'

  @new: (data) -> new @ data

  constructor: (data) ->
    util._extend @, data if data
