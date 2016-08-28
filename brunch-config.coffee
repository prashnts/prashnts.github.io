# noop.pw
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
      globals: ['DEBUG']

  npm:
    enabled: yes
    styles:
      'normalize.css': [
        'normalize.css'
      ]

  modules:
    nameCleaner: (path) ->
      path
        .replace /^riptide\//, ''
        .replace /\.coffee/, ''

  files:
    javascripts:
      entryPoints:
        'riptide/app.coffee': 'js/app.js'
    stylesheets:
      joinTo:
        'css/app.css': /^riptide\//
