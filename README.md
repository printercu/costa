# Costa

Built with [CoffeeClasskit](https://github.com/printercu/coffee_classkit) &
[FlowCoffee](https://github.com/printercu/flow-coffee).
Inspired by Rails. Is kept tiny to be fast as fire.

## How can it look like

### Controller

```coffee
Post = require '../models/post'
resource_class = Post

module.exports =
class PostsController extends require './application_controller'
  @extendsWithProto()

  @beforeFilter 'buildResource', only: ['new', 'create']
  @beforeFilter 'findResource', only: ['show', 'edit', 'update', 'delete']

  indexAction: ->
    resource_class.all @handleErrors (err, @collection) =>
      @render {@collection}

  newAction: ->
    @render {@resource}

  createAction: ->
    @resource.save (err) =>
      if err
        if @resource.errors.hasAny
          @res.format
            json: => @res.status(422).jsonp @resource.exportFor 'api' # unprocessable_entity
            html: =>
              @res.flash 'error', @resource.errors.first()
              @res.redirect "/posts/new"
        else
          @next(err)
      else
        url = "/posts/#{@resource.id}"
        @res.format
          json: => @res.status(201).set('Location', url).jsonp @resource.exportFor 'api' # created
          html: =>
            @res.flash 'Item created'
            @res.redirect url

  showAction: ->
    @render {@resource}

  editAction: ->
    @render {@resource}

  updateAction: ->
    @resource.update @itemParams, (err) =>
      if err
        if @resource.errors.hasAny
          @res.format
            json: => @res.status(422).jsonp @resource.exportFor 'api' # unprocessable_entity
            html: =>
              @res.flash 'error', @resource.errors.first()
              @res.redirect "/posts/#{@resource.id}/edit"
        else
          @next(err)
      else
        url = "/posts/#{@resource.id}"
        @res.format
          json: => @res.jsonp @resource.exportFor 'api'
          html: =>
            @res.flash 'Item updated'
            @res.redirect url

  buildResource: (callback) ->
    @resource = resource_class.create @itemParams
    callback()

  findResource: (callback) ->
    resource_class.find @req.param('id'), @handleErrors (err, @resource) =>
      callback()

  allowed_params = [
    'title'
    'body_md'
  ]

  Object.defineProperty @::, 'itemParams', get: ->
    @params allowed_params...
```

And now just call `PostsController.dispatch(action, req, res, next)`
the way you like with `action` one of `index, new, create, show, edit, update, destroy`.

### Model

```coffee
marked  = require 'marked'
hljs    = require 'highlight.js'
_       = require 'lodash'

module.exports =
class Post extends require './base_record'
  @extendsWithProto()

  @include require './concerns/with_fixtures'

  @MARKED_OPTIONS =
    highlight: (code, lang) ->
      code = 'coffeescript' if code is 'coffee'
      try
        return hljs.highlight(lang, code).value
      catch error
        return hljs.highlightAuto(code).value

  @exportAttrs 'body', 'body_md', 'title', 'created_at'

  @validatesPresenceOf 'body_md', 'title'

  @beforeCreate (callback) ->
    @created_at = new Date
    callback()

  @beforeSave (callback) ->
    @compileBody()
    callback()

  @all: (callback) ->
    @maxId (err, max_id) =>
      return callback err if err
      @getMulti [1..max_id], (err, items) ->
        return callback err if err
        callback err, _.compact items

  compileBody: ->
    @body = marked @body_md, @constructor.MARKED_OPTIONS
```

## More documentation in tests & source

## License

MIT
