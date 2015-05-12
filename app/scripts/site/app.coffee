
Backbone   = require 'backbone'
Backbone.$ = require 'jquery'
Router =  require './router'

demoClass = require './gl/demos/audioShaderDemo.coffee'
GlView =  require './gl/view'

#Demos = require './demos'

class App

  isDebugging:true

  constructor: ->
    #@demos = new Demos()
    @router = new Router()
    @__routeHandlers()
    Backbone.history.start()

  __routeHandlers: ->
    @router.on 'route:index', @appIndex

  appIndex: =>
    View = new GlView(el: 'body', demo:new demoClass({debug:@isDebugging}))

app = new App()
