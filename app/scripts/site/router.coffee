Backbone   = require 'backbone'

AppRouter = Backbone.Router.extend

  constructor: ->
    @route("", "index")
    @route("!/play", "play")
    @

module.exports = AppRouter
