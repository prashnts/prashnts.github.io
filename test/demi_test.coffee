'use strict'
{expect} = require 'chai'
moment = require 'moment'
Demi = require '../demi'

describe 'Demi', ->
  it 'should be a function', ->
    expect(Demi).to.be.a 'function'

  it 'should instantiate with a valid yaml', ->
    d = new Demi '- foo'
    expect(d._doc).to.be.an 'array'
    expect(d._doc).to.contain 'foo'

  describe '#renderDateInterval', ->
    d = new Demi ''
    # NOTE: Pin _now to some date otherwise these tests will break next year.
    d._now = moment('2016-09-21')

    it 'should be a valid function', ->
      expect(d).to.respondTo 'renderDateInterval'

    it 'allows `till` parameter to be empty and renders "present"', ->
      r = d.renderDateInterval '2016-01-01'
      expect(r).to.be.a('string').that.contains 'Present'

    it 'does not render year for first if both fall under same year', ->
      r = d.renderDateInterval '2016-01-01', '2016-02-01'
      expect(r).to.equal 'Jan -- Feb 2016'

    it 'does render year for first otherwise', ->
      r = d.renderDateInterval '2015-01-01', '2016-02-01'
      expect(r).to.equal 'Jan 2015 -- Feb 2016'

    it 'renders dates if ranges are in same month', ->
      r = d.renderDateInterval '2016-02-01', '2016-02-05'
      expect(r).to.equal '1 -- 5 Feb 2016'

    it 'renders year if `till` is not given and it isnt in current year', ->
      r = d.renderDateInterval '2015-02-01'
      expect(r).to.equal 'Feb 2015 -- Present'

    it 'does not render year in absence of `till` it being current year', ->
      r = d.renderDateInterval '2016-02-01'
      expect(r).to.equal 'Feb -- Present'
