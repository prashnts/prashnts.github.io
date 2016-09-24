# noop.pw
{renderVita} = require './demi'
global.vita = renderVita './riptide/vita.yaml'
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
      globals: ['DEBUG', 'festus']
    closurecompiler:
      compilationLevel: 'ADVANCED'
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
        # 'css/app.css': /^riptide\//
