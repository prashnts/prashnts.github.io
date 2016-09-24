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
    it 'renders dates and descriptions', ->
      f = new Festus today: '2016-09-21'
      input =
        dates: from: '2015-06-15'
        description: '_wow_'
      known =
        dates: 'Jun 2015 － Present'
        description: '<p><em>wow</em></p>\n'
      expect(f.render input).to.deep.equal known

    it 'renders nested content', ->
      f = new Festus today: '2018-09-21'
      input =
        dates: from: '2015-06-15'
        foo: bar: dates:
          from: '2016-02-01'
          till: '2016-03-01'
        description: '_wow_'
      known =
        dates: 'Jun 2015 － Present'
        foo: bar: dates: 'Feb － Mar 2016'
        description: '<p><em>wow</em></p>\n'
      expect(f.render input).to.deep.equal known

