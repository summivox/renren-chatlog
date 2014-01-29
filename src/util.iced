###
 *!util
###

util = {}

util.encodeFormData = (o) ->
  (encodeURIComponent(key) + '=' + encodeURIComponent(value) for own key, value of o).join '&'

util.flatten = (arrays) -> [].concat.apply [], arrays

util.download = (cont, type, name) ->
  saveAs new Blob([cont], {type}), name
