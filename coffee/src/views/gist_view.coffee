goog.provide 'athena.lib.GistView'
goog.require 'athena.lib.DocView'

# view for rendering markdown documents
class athena.lib.GistView extends athena.lib.DocView


  className: @classNameExtend 'gist-view'


  defaults: => _.extend super,

    # gist document id
    gist: undefined

    # the files to concatenate -- undefined concatenates all.
    files: undefined

    # function to render the document source
    render: athena.lib.DocView.renderMarkdown

  initialize: =>
    super
    @gist @options.gist


  gist: (gist) =>
    if gist?
      @_gist = gist

      $.ajax
        url: "https://api.github.com/gists/#{gist}"
        dataType: 'jsonp'
        success: (data) =>
          @doc @parseGist data
          @softRender()
        error: (xhr) =>
          @doc 'Error retrieving gist.'
          @softRender()
          console.log xhr.responseText

    @_gist


  parseGist: (data) =>
    files = @options.files ? _.keys data.data.files
    files = _.map files, (file) => data.data.files[file]
    _.pluck(files, 'content').join '\n\n'
