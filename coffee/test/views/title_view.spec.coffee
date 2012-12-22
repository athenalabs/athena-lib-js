goog.provide 'athena.lib.specs.TitleView'

goog.require 'athena.lib.util'
goog.require 'athena.lib.TitleView'

describe 'athena.lib.TitleView', ->
  TitleView = athena.lib.TitleView

  options = model: {text: 'Title'}

  test.describeView TitleView, athena.lib.View, options, ->

    it 'should have tagName span', ->
      expect(TitleView::tagName).toBe 'span'

    it 'should throw an error if model with text is not given', ->
      expect(-> new TitleView).toThrow()
      expect(-> new TitleView model: {}).toThrow()
      expect(-> new TitleView model: {text: 'foo'}).not.toThrow()

    it 'should look good', ->
      # create a div to safely append content to the page
      $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

      models = [
        {text: 'Foo'},
        {text: 'Bar', link: '/bar'},
        {text: 'Walrus', icon:
          'http://static.benet.ai/skitch/walruswins-20121221-143752.png'}
      ]

      for model in models
        view = new TitleView model: model
        view.render()
        view.$el.css('margin', '20px').css('display', 'block')
        $safe.append view.$el


  describe 'TitleView::render', ->

    it 'should render given text', ->
      view = new TitleView model: {text: 'foo'}
      view.render()
      expect(view.$(view.options.titleTag).text()).toBe 'foo'

    it 'should render an img with given icon src', ->
      view = new TitleView model: {text: 'foo', icon: 'bar.png'}
      view.render()
      expect(view.$('img').attr 'src').toBe 'bar.png'

    it 'should render a link with given link href', ->
      view = new TitleView model: {text: 'foo', link: '/bar'}
      view.render()
      expect(view.$('a').attr 'href').toBe '/bar'

    it 'should render text inside given tag', ->
      view = new TitleView model: {text: 'foo'}, titleTag: 'h5'
      view.render()
      expect(view.$('h5').text()).toBe 'foo'
