# noop.pw
moment = require 'moment'
{renderVita} = require './demi'
global.vita = renderVita './riptide/vita.yaml'
global._now = moment()
global.DEBUG = '-p' not in global.process.argv

module.exports = config:
  paths:
    watched: ['riptide']

  plugins:
    autoReload:
      enabled: yes
    coffeelint:
      pattern: /^riptide\/.*\.(coffee)$/
      useCoffeelintJson: yes
    jaded:
      staticPatterns: /^riptide\/markup\/([\d\w]*)\.jade$/
      globals: ['DEBUG', 'vita', '_now']
    closurecompiler:
      compilationLevel: 'SIMPLE'
    typeset:
      tweaks: disable: ['ligatures']
    stylus:
      plugins: [
        'jeet'
        'axis'
      ]

  conventions:
    ignored: [
      /node_modules\/jade/
      /(templates|partials)\/.+\.jade$/
    ]

  hooks:
    onCompile: ->
      global.vita = renderVita './riptide/vita.yaml'

  npm:
    enabled: yes
    styles:
      'normalize.css': ['normalize.css']

  modules:
    nameCleaner: (path) ->
      path
        .replace /^riptide\//, ''
        .replace /\.coffee/, ''

  files:
    javascripts:
      joinTo: 'js/app.js'
    stylesheets:
      joinTo: 'css/app.css'

  server:
    command: "node_modules/.bin/http-server -c-1 -p #{process.env.PORT or 8080}"
