###*
# The Main enterance Into my App
#
# @classView
# @constructor
#
###
Backbone   = require 'backbone'
module.exports = Backbone.View.extend

  template: require './formTemplate'
  events:
    "click #Submit" : "submit"

  initialize:(options) ->
    @Info = options.model
    @render()

  render: ->
    @$el.html @template

  submit: ->
    @Info.set('xColor',@$('#X-Color')[0].value)
    @Info.set('yColor',@$('#Y-Color')[0].value)
    @Info.set('zColor',@$('#Z-Color')[0].value)

    @Info.set('shapeCount',parseInt(@$('#Shape-Count')[0].value),10)
    @Info.set('shapeSize',parseInt(@$('#Shape-Size')[0].value),10)

    @Info.set('xRotation',parseFloat(@$('#X-Rotation')[0].value),10)
    @Info.set('yRotation',parseFloat(@$('#Y-Rotation')[0].value),10)
    @Info.set('zRotation',parseFloat(@$('#Z-Rotation')[0].value),10)


    @Info.set('xBound',parseInt(@$('#X-Distance')[0].value),10)
    @Info.set('yBound',parseInt(@$('#Y-Distance')[0].value),10)


    @Info.set('VMax',parseFloat(@$('#Vert-Jitter')[0].value),10)
    @Info.set('HMax',parseFloat(@$('#Horz-Jitter')[0].value),10)


    Backbone.router.navigate("#!/play", {trigger: true})
    # xColor:0xff0000
    # yColor:0x00ff00
    # zColor:0x0000ff
    # shapeCount:5
