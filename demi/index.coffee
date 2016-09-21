yaml = require 'js-yaml'
marked = require 'marked'
moment = require 'moment'
fs = require 'fs'


class Demi
  constructor: (fcontent) ->
    @_doc = yaml.safeLoad fcontent
    @_now = moment()

  renderDateInterval: (from, till) ->
    [start, end] = [moment(from), moment(till)]
    unless start.isValid() or end.isValid()
      throw new Error 'Invalid Dates'

    if till?
      if start.isSame(end, 'year')
        if start.isSame(end, 'month')
          "#{start.format('D')} -- #{end.format('D MMM Y')}"
        else
          "#{start.format('MMM')} -- #{end.format('MMM Y')}"
      else
        "#{start.format('MMM Y')} -- #{end.format('MMM Y')}"
    else
      _present = 'Present'
      if start.isSame(@_now, 'year')
        "#{start.format('MMM')} -- #{_present}"
      else
        "#{start.format('MMM Y')} -- #{_present}"


module.exports = Demi
