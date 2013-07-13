module.exports =
class Errors extends require('coffee_classkit').Module
  @extendsWithProto()

  constructor: ->
    @messages = {}

  clear: ->
    @messages = {}
    @

  has: (field) ->
    @messages[field]?.length

  hasAny: ->
    return true for error of @messages
    false

  first: ->
    return @messages[error][0] for error of @messages when @messages[error].length
    false

  add: (field, message) ->
    [field, message] = ['base', field] unless message
    (@messages[field] ||= []).push message
    @
