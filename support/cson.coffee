coffee = require 'coffee-script'
require.extensions['.cson'] = (module, filename) ->
  content = require('fs').readFileSync filename, 'utf8'
  try
    module.exports = eval coffee.compile content, bare: true
  catch err
    err.message = filename + ': ' + err.message
    throw err
