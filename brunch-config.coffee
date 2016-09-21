# noop.pw
# demi = require './demi'
# global.vita = demi './riptide/vita.yaml'
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
      globals: ['DEBUG', 'vita']
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
    ]

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
