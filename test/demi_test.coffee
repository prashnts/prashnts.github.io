{expect} = require 'chai'

{Demi, Festus} = require '../demi/demi'

describe 'Demi', ->
  it 'is a function', ->
    expect(Demi).to.be.a 'function'

  describe '#constructor', ->
    it 'uses instantiated settings', ->
      d = new Demi null, '*'
      expect(d.renderDateInterval '2016-01-01').to.contain ' * '

  describe '#renderDateInterval', ->
    # NOTE: Pin _now to some date otherwise these tests will break next year.
    d = new Demi '2016-09-21'

    it 'should be a valid function', ->
      expect(d).to.respondTo 'renderDateInterval'

    it 'allows `till` parameter to be empty and renders "present"', ->
      r = d.renderDateInterval '2016-01-01'
      expect(r).to.be.a('string').that.contains 'Present'

    it 'does not render year for first if both fall under same year', ->
      r = d.renderDateInterval '2016-01-01', '2016-02-01'
      expect(r).to.equal 'Jan － Feb 2016'

    it 'does render year for first otherwise', ->
      r = d.renderDateInterval '2015-01-01', '2016-02-01'
      expect(r).to.equal 'Jan 2015 － Feb 2016'

    it 'renders dates if ranges are in same month', ->
      r = d.renderDateInterval '2016-02-01', '2016-02-05'
      expect(r).to.equal '1 － 5 Feb 2016'

    it 'renders year if `till` is not given and it isnt in current year', ->
      r = d.renderDateInterval '2015-02-01'
      expect(r).to.equal 'Feb 2015 － Present'

    it 'does not render year in absence of `till` it being current year', ->
      r = d.renderDateInterval '2016-02-01'
      expect(r).to.equal 'Feb － Present'

    it 'fails when `from` is missing', ->
      expect(-> d.renderDateInterval()).to.throw Error

    it 'fails when `from` is invalid', ->
      expect(-> d.renderDateInterval('foobar')).to.throw Error

    it 'fails when `till` is invalid', ->
      expect(-> d.renderDateInterval('2016-02-01', 'foobar')).to.throw Error

  describe '#renderDuration', ->
    d = new Demi '2016-09-21'

    it 'should be a valid function', ->
      expect(d).to.respondTo 'renderDuration'

    it 'compensates missing `till` for `now`', ->
      r = d.renderDuration '2016-01-01'
      expect(r).to.equal '9 Months'

    it 'does not render if the dates are less than two months apart', ->
      r = d.renderDuration '2016-01-01', '2016-02-01'
      expect(r).to.be.undefined

    it 'renders month counts when they are more than two month apart', ->
      r = d.renderDuration '2016-01-01', '2016-03-01'
      expect(r).to.equal '2 Months'

    it 'renders month counts until dates are ~12 months apart', ->
      r = d.renderDuration '2016-01-01', '2016-12-29'
      expect(r).to.equal '1 Year'

    it 'renders year and month counts when dates are more than a year apart', ->
      r = d.renderDuration '2016-01-01', '2017-08-29'
      expect(r).to.equal '1 Year 8 Months'

    it 'renders year and months correctly when dates are few years apart', ->
      r = d.renderDuration '2016-01-01', '2019-08-29'
      expect(r).to.equal '3 Years 8 Months'

    it 'renders year and months correctly when dates are few years apart', ->
      r = d.renderDuration '2016-01-01', '2018-01-01'
      expect(r).to.equal '2 Years'

  describe '#renderMarkdown', ->
    it 'correctly renders markdown', ->
      d = new Demi
      input = 'Foo **bar** _baz_.'
      known = '<p>Foo <strong>bar</strong> <em>baz</em>.</p>\n'
      expect(d.renderMarkdown input).to.equal known

describe 'Festus', ->
  it 'is a function', ->
    expect(Festus).to.be.a 'function'

  describe '#_mapDeep', ->
    d = new Festus

    it 'does not mutate object', ->
      data = foo: 'bar'
      out = d._mapDeep data, 'foo', (n) -> n.toUpperCase()
      expect(out.foo).to.equal 'BAR'
      expect(data.foo).to.equal 'bar'

    it 'does not mutate nested objects', ->
      data =
        foo:
          bar:
            baz: 'i'
            bat: 'nope'
          baz: 'd'
        baz: 'k'
        doom: 'man'
      known =
        foo:
          bar:
            baz: 'I'
            bat: 'nope'
          baz: 'D'
        baz: 'K'
        doom: 'man'
      out = d._mapDeep data, 'baz', (n) -> n.toUpperCase()
      expect(out).to.deep.equal known
      expect(out).to.not.deep.equal data

  describe '#render', ->
    it 'renders dates, duration and descriptions', ->
      f = new Festus today: '2016-09-21'
      input =
        dates: from: '2015-06-15'
        description: '_wow_'
      known =
        dates:
          interval: 'Jun 2015 － Present'
          duration: '1 Year 3 Months'
        description: '<p><em>wow</em></p>\n'
      expect(f.render input).to.deep.equal known

    it 'renders nested content', ->
      f = new Festus today: '2018-09-21'
      input =
        dates: from: '2015-06-15'
        foo: bar: dates:
          from: '2016-02-01'
          till: '2016-05-01'
        description: '_wow_'
      known =
        dates:
          interval: 'Jun 2015 － Present'
          duration: '3 Years 3 Months'
        foo: bar:
          dates:
            interval: 'Feb － May 2016'
            duration: '3 Months'
        description: '<p><em>wow</em></p>\n'
      expect(f.render input).to.deep.equal known

