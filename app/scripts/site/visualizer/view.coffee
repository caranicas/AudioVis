###*
# The Visualizer
#
# @classView
# @constructor
#
###
Backbone   = require 'backbone'
AudioReactive = require './audioReactive.coffee'

module.exports = Backbone.View.extend

  template: require './template'

  initialize:(options) ->
    console.log 'options', options.model
    @Reactive  = new AudioReactive(debug:options.debug, info: options.model)
    @render()

  render: ->
    @$el.html @template
    @$('canvas')[0].webkitRequestFullScreen()
    @Reactive.init()
    @Reactive.loop()
