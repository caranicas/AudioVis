
Backbone   = require 'backbone'
Backbone.$ = require 'jquery'
Router =  require './router'
IndexView = require './form/indexView'
GlView =  require './visualizer/view'
InfoMod = require './visInfo'

class App

  isDebugging:false
  constructor: ->
    @Info = new InfoMod()
    @router = Backbone.router = new Router()
    @__routeHandlers()
    Backbone.history.start()

  __routeHandlers: ->
    @router.on 'route:index', @appIndex
    @router.on 'route:play', @appPlay

  appIndex: =>
    View = new IndexView(el: 'body', model:@Info)
  appPlay: =>
    View = new GlView(el: 'body', debug:@isDebugging, model:@Info)

app = new App()
