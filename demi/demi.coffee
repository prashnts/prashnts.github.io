marked = require 'marked'
moment = require 'moment'


class Demi
  constructor: (today, separator) ->
    @_init_markdn()
    @_now = moment(today)
    @_sep = separator or '--'

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

  renderMarkdown: (content) => @marked content

  _init_markdn: ->
    renderer = new marked.Renderer
    renderer.heading = (txt, level) ->
      # Offset headings by two levels.
      slug = txt.toLowerCase().replace /[^\w]+/g, '_'
      lvl = level + 2
      "<h#{lvl}>#{txt}</h#{lvl}>"
    @marked = (dat) -> marked dat, renderer: renderer


class Festus
  constructor: (opts = {}) ->
    {today, separator} = opts
    demi = new Demi today, separator

    _dtKey = opts.dateKey or 'dates'
    _mdKey = opts.mdKey or 'description'
    @renderDates = @getMap _dtKey, (node) ->
      demi.renderDateInterval node.from, node.till
    @renderMarkdown = @getMap _mdKey, demi.renderMarkdown

  _mapDeep: (obj, pivot, fn) ->
    accumulate = (dat) ->
      _d = Object.assign {}, dat
      for own key, value of dat
        if key is pivot
          _d[key] = fn value
        else if typeof value is 'object'
          _d[key] = accumulate value
      _d
    accumulate obj

  getMap: (pivot, fn) -> (obj) => @_mapDeep obj, pivot, fn

  render: (dict) ->
    @renderDates @renderMarkdown dict



module.exports = {Demi, Festus}
