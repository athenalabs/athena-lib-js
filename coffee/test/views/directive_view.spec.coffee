goog.provide 'athena.lib.specs.DirectiveView'

goog.require 'athena.lib.util'
goog.require 'athena.lib.DirectiveView'
goog.require 'athena.lib.TitleView'

describe 'athena.lib.DirectiveView', ->
  DirectiveView = athena.lib.DirectiveView
  TitleView = athena.lib.TitleView
  View = athena.lib.View

  test.describeView DirectiveView, athena.lib.View, ->

    it 'should have tagName span', ->
      expect(DirectiveView::tagName).toBe 'span'

    it 'should look good', ->
      # create a div to safely append content to the page
      $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

      sets = [
        ['Foo', 'Bar'],
        'abcdefg'.split(''),
        (new TitleView model:{text: title}) for title in ['Foo', 'Bar'],
      ]

      for set in sets
        view = new DirectiveView parts: set
        view.render()
        view.$el.css('margin', '20px').css('display', 'block')
        $safe.append view.$el


  describe 'DirectiveView::parts', ->

    it 'should be an array', ->
      expect(_.isArray new DirectiveView().parts).toBe true

    it 'should be empty at first', ->
      expect(_.isEmpty new DirectiveView().parts).toBe true

    it 'should be set by options.parts', ->
      parts = [new View, new View, new View]
      view = new DirectiveView parts: parts
      expect(view.parts).toEqual parts

    it 'should be a clone, not options.parts', ->
      parts = [new View, new View, new View]
      view = new DirectiveView parts: parts
      expect(view.parts).toEqual parts
      expect(view.parts).not.toBe parts


  describe 'DirectiveView::addPart', ->

    it 'should be a function', ->
      expect(typeof DirectiveView::addPart).toBe 'function'

    it 'should add part to DirectiveView::parts', ->
      view = new DirectiveView
      view.addPart 'a'
      view.addPart 'b'
      view.addPart 'c'
      view.addPart 'd'
      expect(view.parts).toEqual ['a', 'b', 'c', 'd']

    it 'should not call DirectiveView::renderPart if not rendering', ->
      view = new DirectiveView
      spy = spyOn view, 'renderPart'
      view.addPart 'a'
      expect(spy).not.toHaveBeenCalled()

    it 'should not call DirectiveView::renderPart if not rendering', ->
      view = new DirectiveView
      view.render()
      spy = spyOn view, 'renderPart'
      view.addPart 'a'
      expect(spy).toHaveBeenCalled()

    it 'should call renderSeparator for all parts that arent the first', ->
      view = new DirectiveView
      view.render()
      spy = spyOn view, 'renderSeparator'
      view.addPart 'a'
      expect(spy).not.toHaveBeenCalled()
      view.addPart 'b'
      expect(spy).toHaveBeenCalled()
      view.addPart 'c'
      expect(spy).toHaveBeenCalled()


  describe 'DirectiveView::renderPart', ->

    it 'should be a function', ->
      expect(typeof DirectiveView::renderPart).toBe 'function'

    it 'should render views and append them', ->
      parts = [new View, new View, new View]
      view = new DirectiveView parts: parts

      view.render()
      for part in parts
        expect(part.rendering).toBe true
        expect(part.el.parentNode).toBe view.el

    it 'should append selectors directly', ->
      parts = [$('<h1>foo</h1>'), $('<h2>bar</h2>')]
      view = new DirectiveView parts: parts

      view.render()
      expect(view.$('h1').text()).toBe 'foo'
      expect(view.$('h2').text()).toBe 'bar'

    it 'should append strings directly', ->
      parts = ['foo', 'bar', 'bazzz']
      view = new DirectiveView parts: parts

      view.render()
      for part in parts
        expect(!!view.$el.text().match ///#{part}///).toBe true

    it 'should be called by render for every part', ->
      view = new DirectiveView parts: ['a', 'b', 'c']
      spy = spyOn view, 'renderPart'
      view.render()
      expect(spy.callCount).toBe 3

    it 'should call renderSeparator for all parts that arent the last', ->
      view = new DirectiveView parts: ['a', 'b', 'c']
      spy = spyOn view, 'renderSeparator'
      view.render()
      expect(spy.callCount).toBe 2
