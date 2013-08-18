_     = require 'underscore'
Args  = require '../support/args'

module.exports =
class Attributes extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  @includedBlock = ->

  class @ClassMethods
    exportAttrs: ->
      @_manageAttrs true, arguments...

    protectAttrs: ->
      @_manageAttrs false, arguments...

    _manageAttrs: (add, args...) ->
      [options, fields] = Args.findOptions args
      types = if options.for then _.flatten [options.for] else ['default']
      for type in types
        @["_attrExported_#{type}"] = _.uniq if add
            @exportedAttrs(type).concat fields
          else
            _.difference @exportedAttrs(type), fields

    # TODO: cache it
    exportedAttrs: (type = 'default') ->
      return @_attrExported_default || [] if type is 'default'
      (@_attrExported_default || []).concat(@["_attrExported_#{type}"] || [])

  # instance methods
  # TODO: force null values
  exportFor: (type) ->
    result = {}
    for attr in @constructor.exportedAttrs(type)
      continue unless @[attr]?
      result[attr] = if typeof (val = @[attr]) is 'function'
        @[attr]()
      else
        val
    result
