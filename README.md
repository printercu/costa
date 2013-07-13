# Costa

Built with [CoffeeClasskit](https://github.com/printercu/coffee_classkit) &
[FlowCoffee](https://github.com/printercu/flow-coffee).
Inspired by Rails. Is kept tiny to be fast as fire.

## How can it look like

### Controller

```coffee
Post          = require '../models/post'
parse_params  = require '../lib/parse_params'

module.exports =
class PostsController extends require './application_controller'
  @extendsWithProto()

  @beforeFilter 'authenticate', only: ['new', 'create', 'edit', 'destroy']
  @beforeFilter 'findItem', only: ['show', 'edit', 'update', 'destroy']

  # actions
  indexAction: ->
    params = @searchParams()
    Post.search params, @handleErrors (err, {items, stats}) =>
      posts = for item in items
        if item then item.exportFor 'api' else item
      @render posts: posts, params: params

  newAction: ->
    @render post: new Post

  createAction: ->
    item = new Post @itemParams()
    item.account_id = @req.account.id
    item.save (err) =>
      if err
        if item.errors.hasAny
          @res.format
            json: -> @status(422).json item.exportFor 'api' # unprocessable_entity
            html: ->
              @flash 'error', item.errors.first()
              @redirect '/posts/new'
        else
          @next(err)
      else
        url = "/posts/#{item.id}"
        @res.format
          json: -> @status(201).set('Location', url).json item.exportFor 'api' # created
          html: ->
            @flash 'Post created'
            @redirect url

  showAction: ->
    @render post: @item.exportFor 'api'

  editAction: ->
    @render post: @item.exportFor 'api'

  updateAction: ->
    item = @item.update @itemParams(), (err) => setImmediate =>
      if err
        if item.errors.hasAny
          @res.format
            json: -> @status(422).json item.exportFor 'api' # unprocessable_entity
            html: ->
              @flash 'error', item.errors.first()
              @redirect "/posts/#{@req.params.id}/edit"
        else
          @next(err)
      else
        @res.format
          json: ->
            if @req.query._response? || @req.body._response?
              @json post: item.exportFor 'api'
            else
              @status(204).end() # no_content
          html: ->
            @flash 'notice', 'Post saved'
            @redirect "/posts/#{@req.params.id}/edit"

  destroyAction: ->
    @item.destroy @handleErrors =>
      @res.format
        json: -> @status(204).end() # no_content
        html: ->
          @flash 'Post deleted'
          @redirect '/posts'

  # filters
  findItem: (callback) ->
    Post.find @req.params.id, @handleErrors (err, item) =>
      @item = item
      callback()

  # strong params
  itemParams: ->
    result = @params Post.exportedAttrs()...
    result.image = image if image = @fileParam 'image'
    result

  searchParams: ->
    str: @req.query.str

```

And now just call `PostsController.dispatch(action, req, res, next)`
the way you like with `action` one of `index, new, create, show, edit, update, destroy`.

### Model

```coffee
module.exports =
class Post extends require './base_record'
  @extendsWithProto()

  @include require './concerns/with_image'

  @exportAttrs 'author_id',
    'title'
    'content'
    'is_published'
    'tags'

  @validatesPresenceOf 'author_id', 'title', 'content'

  @beforeSave 'refreshTags'

  refreshTags: (callback) ->
    some_tag_parser.parse @content, (err, tags) =>
      return callback err if err
      @tags = tags
      callback()
```

## More documentation in tests & source

## License

MIT
