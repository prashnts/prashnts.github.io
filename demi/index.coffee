fs = require 'fs'
yaml = require 'js-yaml'

{Festus} = require './demi'

renderVita = (flpath) ->
  festus = new Festus
  content = yaml.safeLoad fs.readFileSync flpath, 'utf-8'
  festus.render content

module.exports = {renderVita}
