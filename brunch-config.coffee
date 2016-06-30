#!/usr/bin/env coffee
# 0xc0d3.pw

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
      joinTo:
        'js/libraries.js': /^(?!riptide\/)/
        'js/app.js': /^riptide\//
    stylesheets:
      joinTo:
        'css/libraries.css': /^(?!riptide\/)/
        'css/app.css': /^riptide\//
