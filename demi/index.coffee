fs = require 'fs'
yaml = require 'js-yaml'

{Festus} = require './demi'

renderVita = (flpath, locale) ->
  festus = new Festus {separator: '->', locale: locale}
  content = yaml.safeLoad fs.readFileSync flpath, 'utf-8'
  festus.render content

renderPdf = ->


module.exports = {renderVita}
