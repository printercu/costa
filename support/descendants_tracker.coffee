module.exports =
class DescendantsTracker
  Object.defineProperty @::, 'directDescendants', get: ->
    return @_directDescendants if @hasOwnProperty '_directDescendants'
    @_directDescendants = []

  Object.defineProperty @::, 'descendants', get: ->
    @directDescendants.concat (x.directDescendants for x in @directDescendants)...

  trackDescendant: (klass) ->
    @directDescendants.push klass

  inherited: (klass) ->
    @trackDescendant klass
    @__proto__.inherited?.call @, klass if @inherited != @__proto__.inherited
