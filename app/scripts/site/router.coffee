Backbone   = require 'backbone'

AppRouter = Backbone.Router.extend

  constructor: ->
    @route("", "index")
    @

module.exports = AppRouter
