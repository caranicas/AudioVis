Backbone   = require 'backbone'


module.exports = Backbone.Model.extend
  defaults:
    xColor:0xff0000
    yColor:0x00ff00
    zColor:0x0000ff
    shapeCount:40
    shapeSize:10
    xRotation:0.01
    yRotation:0.02
    zRotation:0
    HMax:0.09
    VMax:0.3

    XBound:100
    YBound:50
