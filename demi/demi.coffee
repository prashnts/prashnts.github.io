marked = require 'marked'
moment = require 'moment'


class Demi
  constructor: (today, separator, locale) ->
    @_init_markdn()
    @_now = moment(today)
    @_sep = separator or '－'
    @_locale = locale

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
      _present =  if @_locale == 'fr' then 'actuel' else 'Present'
      if start.isSame(@_now, 'year')
        "#{start.format('MMM')} #{@_sep} #{_present}"
      else
        "#{start.format('MMM Y')} #{@_sep} #{_present}"

  renderDuration: (from, till) ->
    start = moment from, moment.ISO_8601
    end = if till? then moment till, moment.ISO_8601 else @_now
    duration = moment.duration end.diff start
    months = Math.round duration.asMonths()
    years = Math.round duration.asYears()

    if 2 <= months < 12
      if @_locale == 'fr' then "#{months} mois" else "#{months} Months"
    else if years >= 1
      # Since we want month along with year, get the floor value.
      month_count = Math.round duration.asMonths()
      months = month_count %% 12
      years = month_count // 12

      # year_verbose = if years > 1 then 'Years' else 'Year'
      if @_locale == 'fr'
        year_verbose = if years > 1 then 'ans' else 'an'
      else
        year_verbose = if years > 1 then 'Years' else 'Year'

      if months > 0
        if @_locale == 'fr'
          month_verbose = if months > 1 then 'mois' else 'mois'
        else
          month_verbose = if months > 1 then 'Months' else 'Month'
        "#{years} #{year_verbose} #{months} #{month_verbose}"
      else
        "#{years} #{year_verbose}"

  renderDate: (date) ->
    dt = moment date, moment.ISO_8601
    dt.format 'MMM Y'

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
    {today, separator, locale} = opts
    moment.locale locale
    demi = new Demi today, separator, locale

    _dtKey = opts.dateKey or 'dates'
    _mdKey = opts.mdKey or 'description'
    @renderDates = @getMap _dtKey, (node) ->
      unless node.on?
        interval: demi.renderDateInterval node.from, node.till
        duration: demi.renderDuration node.from, node.till
      else
        interval: demi.renderDate node.on
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

  render: (dict, locale) ->
    @renderDates @renderMarkdown dict, locale

  dateOverlaps: (dates) ->
    pass


module.exports = {Demi, Festus}
