goog.provide 'athena.lib.specs.util'

goog.require 'athena.lib.util'


describe 'athena.lib.util', ->
  util = athena.lib.util

  it 'should be part of athena.lib', ->
    expect(athena.lib.util).toBeDefined()

  it 'should be an object', ->
    expect(_.isObject util).toBe true

  describe 'util.derives', ->
    it 'should be a function', ->
      expect(_.isFunction util.derives).toBe true

    class A
    class AB extends A
    class AC extends A
    class ABD extends AB
    class ACE extends AC
    class ACEF extends ACE
    class ACEFG extends ACEF

    expectDerives = (a, b) -> expect(util.derives a, b).toBe true
    expectDerivesNot = (a, b) -> expect(util.derives a, b).toBe false

    it 'should correctly identify classes that derive', ->
      expectDerives AB, A
      expectDerives AC, A
      expectDerives ABD, A
      expectDerives ABD, AB
      expectDerives ACE, A
      expectDerives ACE, AC
      expectDerives ACEF, A
      expectDerives ACEF, AC
      expectDerives ACEF, ACE
      expectDerives ACEFG, A
      expectDerives ACEFG, AC
      expectDerives ACEFG, ACE
      expectDerives ACEFG, ACEF

    it 'should correctly identify classes that do not derive', ->
      expectDerivesNot A, A
      expectDerivesNot A, AB
      expectDerivesNot A, AC
      expectDerivesNot A, ABD
      expectDerivesNot AB, ABD
      expectDerivesNot A, ACE
      expectDerivesNot AC, ACE
      expectDerivesNot A, ACEF
      expectDerivesNot AC, ACEF
      expectDerivesNot ACE, ACEF
      expectDerivesNot A, ACEFG
      expectDerivesNot AC, ACEFG
      expectDerivesNot ACE, ACEFG
      expectDerivesNot ACEF, ACEFG
      expectDerivesNot ABD, AC
      expectDerivesNot ACE, AB
      expectDerivesNot ACEF, AB
      expectDerivesNot ACEF, ABD
      expectDerivesNot ACEFG, AB
      expectDerivesNot ACEFG, ABD

  describe 'util.isOrDerives', ->
    it 'should be a function', ->
      expect(_.isFunction util.isOrDerives).toBe true

    class A
    class AB extends A
    class AC extends A
    class ABD extends AB
    class ACE extends AC
    class ACEF extends ACE
    class ACEFG extends ACEF

    expectIsOrDerives = (a, b) -> expect(util.isOrDerives a, b).toBe true
    expectIsOrDerivesNot = (a, b) -> expect(util.isOrDerives a, b).toBe false

    it 'should correctly identify classes that derive', ->
      expectIsOrDerives A, A
      expectIsOrDerives AB, A
      expectIsOrDerives AC, A
      expectIsOrDerives ABD, A
      expectIsOrDerives ABD, AB
      expectIsOrDerives ACE, A
      expectIsOrDerives ACE, AC
      expectIsOrDerives ACEF, A
      expectIsOrDerives ACEF, AC
      expectIsOrDerives ACEF, ACE
      expectIsOrDerives ACEFG, A
      expectIsOrDerives ACEFG, AC
      expectIsOrDerives ACEFG, ACE
      expectIsOrDerives ACEFG, ACEF

    it 'should correctly identify classes that do not derive', ->
      expectIsOrDerivesNot A, AB
      expectIsOrDerivesNot A, AC
      expectIsOrDerivesNot A, ABD
      expectIsOrDerivesNot AB, ABD
      expectIsOrDerivesNot A, ACE
      expectIsOrDerivesNot AC, ACE
      expectIsOrDerivesNot A, ACEF
      expectIsOrDerivesNot AC, ACEF
      expectIsOrDerivesNot ACE, ACEF
      expectIsOrDerivesNot A, ACEFG
      expectIsOrDerivesNot AC, ACEFG
      expectIsOrDerivesNot ACE, ACEFG
      expectIsOrDerivesNot ACEF, ACEFG
      expectIsOrDerivesNot ABD, AC
      expectIsOrDerivesNot ACE, AB
      expectIsOrDerivesNot ACEF, AB
      expectIsOrDerivesNot ACEF, ABD
      expectIsOrDerivesNot ACEFG, AB
      expectIsOrDerivesNot ACEFG, ABD


  describe 'util.elementInDom', ->
    elementInDom = util.elementInDom

    it 'should exist', ->
      expect(elementInDom).toBeDefined()
      expect(typeof elementInDom).toBe 'function'

    it 'should return false when called with one element not in the DOM', ->
      div = $ '<div>'
      expect(elementInDom div).toBe false

    it 'should return true when called with one element in the DOM', ->
      div = $ '<div>'
      $('body').append div
      expect(elementInDom div).toBe true
      div.remove()

    it 'should return false when called with multiple elements not in the DOM', ->
      container = $ '<div>'
      for i in [0...5]
        container.append $ '<div>'

      divs = container.children()
      expect(elementInDom divs).toBe false

    it 'should return true when called with multiple elements all in the DOM', ->
      container = $ '<div>'
      for i in [0...5]
        container.append $ '<div>'

      divs = container.children()
      $('body').append container
      expect(elementInDom divs).toBe true
      container.remove()


  describe 'util.socialPlugins', ->
    socialPlugins = util.socialPlugins

    it 'should exist', ->
      expect(socialPlugins).toBeDefined()

    it 'should be an object', ->
      expect(typeof socialPlugins).toBe 'object'


    describe 'util.socialPlugins.initialize', ->
      initialize = socialPlugins.initialize

      it 'should exist', ->
        expect(initialize).toBeDefined()

      it 'should be a function', ->
        expect(typeof initialize).toBe 'function'

      it 'should create a facebook js sdk script tag and initialize the FB js
          sdk when passed a facebook appId', ->
        script = $ 'script#facebook-jssdk'
        expect(script.length).toBe 0
        $('body').prepend('<div id="fb-root"></div>')

        expect(window.FB).toBeUndefined()
        initialize facebook: appId: 'fakeid'
        script = $ 'script#facebook-jssdk'
        expect(script.length).toBe 1
        expect(script.attr 'src').toBe '//connect.facebook.net/en_US/all.js'

        expect(window.FB).toBeUndefined()
        waitsFor (->
          window.FB?.api?
        ), 'window.FB.api to be defined', 5000

      it 'should create a google +1 script tag and initialize the google api
          when passed googlePlus: true', ->
        script = $ 'script#g-plus1'
        expect(script.length).toBe 0

        expect(window.gapi).toBeUndefined()
        initialize googlePlus: true
        script = $ 'script#g-plus1'
        expect(script.length).toBe 1
        expect(script.attr 'src').toBe 'https://apis.google.com/js/plusone.js'

        expect(window.gapi).toBeUndefined()
        waitsFor (->
          window.gapi
        ), 'window.gapi to be defined', 5000


      it 'should create a twitter widgets script tag and initialize the twitter
          api when passed twitter: true', ->
        script = $ 'script#twitter-wjs'
        expect(script.length).toBe 0

        expect(window.twttr).toBeUndefined()
        initialize twitter: true
        script = $ 'script#twitter-wjs'
        expect(script.length).toBe 1
        expect(script.attr 'src').toBe 'https://platform.twitter.com/widgets.js'

        expect(window.twttr).toBeUndefined()
        waitsFor (->
          window.twttr
        ), 'window.twttr to be defined', 5000


    describe 'util.socialPlugins.facebookLogin', ->
      facebookLogin = socialPlugins.facebookLogin

      it 'should exist', ->
        expect(facebookLogin).toBeDefined()

      it 'should be a function', ->
        expect(typeof facebookLogin).toBe 'function'

      beforeEach ->
        window.FB ?=
          getLoginStatus: ->
          login: ->

        spyOn window.FB, 'getLoginStatus'
        spyOn window.FB, 'login'

      it 'should call FB.getLoginStatus', ->
        expect(FB.getLoginStatus).not.toHaveBeenCalled()
        facebookLogin()
        expect(FB.getLoginStatus).toHaveBeenCalled()

      it 'should pass FB.getLoginStatus a callback', ->
        expect(FB.getLoginStatus).not.toHaveBeenCalled()
        facebookLogin()
        expect(FB.getLoginStatus).toHaveBeenCalled()
        expect(typeof FB.getLoginStatus.mostRecentCall.args[0]).toBe 'function'


      describe 'facebookLogin: getLoginStatus status == "connected"', ->

        it 'should call a success callback', ->
          options = success: jasmine.createSpy 'success'

          facebookLogin options
          statusHandler = FB.getLoginStatus.mostRecentCall.args[0]

          expect(options.success).not.toHaveBeenCalled()
          statusHandler status: 'connected'
          expect(options.success).toHaveBeenCalled()


      describe 'facebookLogin: getLoginStatus status != "connected"', ->

        it 'should call FB.login', ->
          facebookLogin()
          statusHandler = FB.getLoginStatus.mostRecentCall.args[0]

          expect(FB.login).not.toHaveBeenCalled()
          statusHandler status: 'not_connected'
          expect(FB.login).toHaveBeenCalled()

        it 'should pass FB.login a callback', ->
          facebookLogin()
          statusHandler = FB.getLoginStatus.mostRecentCall.args[0]

          expect(FB.login).not.toHaveBeenCalled()
          statusHandler status: 'not_connected'
          expect(FB.login).toHaveBeenCalled()
          expect(typeof FB.login.mostRecentCall.args[0]).toBe 'function'


        describe 'facebookLogin: login authResponse is truthy', ->

          it 'should call a success callback', ->
            options = success: jasmine.createSpy 'success'

            facebookLogin options
            statusHandler = FB.getLoginStatus.mostRecentCall.args[0]

            statusHandler status: 'not_connected'
            expect(FB.login).toHaveBeenCalled()

            loginHandler = FB.login.mostRecentCall.args[0]

            expect(options.success).not.toHaveBeenCalled()
            loginHandler authResponse: true
            expect(options.success).toHaveBeenCalled()


        describe 'facebookLogin: login authResponse is falsy', ->

          it 'should call a failure callback', ->
            options = failure: jasmine.createSpy 'failure'

            facebookLogin options
            statusHandler = FB.getLoginStatus.mostRecentCall.args[0]

            statusHandler status: 'not_connected'
            expect(FB.login).toHaveBeenCalled()

            loginHandler = FB.login.mostRecentCall.args[0]

            expect(options.failure).not.toHaveBeenCalled()
            loginHandler authResponse: false
            expect(options.failure).toHaveBeenCalled()


    describe 'util.socialPlugins.facebookPicture', ->
      facebookPicture = socialPlugins.facebookPicture

      it 'should exist', ->
        expect(facebookPicture).toBeDefined()

      it 'should be a function', ->
        expect(typeof facebookPicture).toBe 'function'

      it 'should return a link to a facebook picture', ->
        picture = facebookPicture 'fake.username'
        picture = picture.split('?')[0]
        expect(picture).toBe '//graph.facebook.com/fake.username/picture'

      it 'should return a picture of size "large" by default', ->
        picture = facebookPicture 'fake.username'
        pictureParams = picture.split('?')[1]
        expect(pictureParams).toBe 'type=large'

      it 'should allow customization of the picture size', ->
        picture = facebookPicture 'fake.username', 'customSize'
        pictureParams = picture.split('?')[1]
        expect(pictureParams).toBe 'type=customSize'
