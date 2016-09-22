yaml = require 'js-yaml'
marked = require 'marked'
moment = require 'moment'
fs = require 'fs'


class Demi
  constructor: (fcontent, today, separator = '--') ->
    @_doc = yaml.safeLoad fcontent
    @_now = moment(today)
    @_sep = separator

  renderDateInterval: (from, till) ->
    start = moment from, moment.ISO_8601
    end = moment till, moment.ISO_8601
    unless from? and start.isValid()
      throw new Error 'Invalid `from` date'
    if till? and not end.isValid()
      throw new Error 'Invalid `till` date'

    if till?
      if start.isSame(end, 'year')
        if start.isSame(end, 'month')
          "#{start.format('D')} #{@_sep} #{end.format('D MMM Y')}"
        else
          "#{start.format('MMM')} #{@_sep} #{end.format('MMM Y')}"
      else
        "#{start.format('MMM Y')} #{@_sep} #{end.format('MMM Y')}"
    else
      _present = 'Present'
      if start.isSame(@_now, 'year')
        "#{start.format('MMM')} #{@_sep} #{_present}"
      else
        "#{start.format('MMM Y')} #{@_sep} #{_present}"

  transform: ->


module.exports = Demi
