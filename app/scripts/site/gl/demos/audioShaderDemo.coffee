THREE = require 'threejs'
Demo = require './DemoInterface'
EffectComposer = require 'effectcomposer'
DotScreenShader = require 'dotscreenshader'
AudioShader = require './../components/shaders/audioShader'

HorizontalShader = require './../components/shaders/HorizontalBlurShader'
VerticalShader = require './../components/shaders/VerticalBlurShader'

Mic = require './../components/audio/microphone'
Mp3 = require './../components/audio/mp3'

class AudioShaderDemo extends Demo

  size:100

  #light values
  topIntensity:1
  leftIntensity:1
  frontIntensity:1
  bottomIntensity:1
  rightIntensity:1
  backIntensity:1
  topColor:0xffffff
  leftColor:0xffffff
  frontColor:0xffffff
  bottomColor:0xffffff
  rightColor:0xffffff
  backColor:0xffffff


  Hmin:0.001
  Hrange:0.049

  Vmin:0.04
  Vrange:0.16

  AudioMax:255

  constructor: ->
    #@@audioStream = new Mic()
    super

  init: ->
    @threeInit()
    @audioStream = new Mp3()

  threeInit: ->
    super
    @__initShader()
    @__createShaderEffects()

  __initShader: ->
    @composer = new EffectComposer( @renderer )
    @composer.addPass( new EffectComposer.prototype.RenderPass( @scene, @camera ) )

  __createShaderEffects: ->

    @Heffect = new EffectComposer.prototype.ShaderPass(new HorizontalShader())
    #@Heffect.renderToScreen = true;
    @Heffect.uniforms[ "h" ].value = @Hmin
    @composer.addPass(@Heffect)

    @Veffect = new EffectComposer.prototype.ShaderPass(new VerticalShader())
    @Veffect.renderToScreen = true;
    @Veffect.uniforms[ "v" ].value = @Vmin
    @composer.addPass(@Veffect)
    #@__audioDotScreen()

  __audioDotScreen:->
    @effect = new EffectComposer.prototype.ShaderPass( new AudioShader() )
    @effect.renderToScreen = true
    @effect.uniforms[ 'scale' ].value = 2
    @composer.addPass( @effect )

  __initLights: ->
    topLight = new THREE.DirectionalLight( 0xff0000, @topIntensity );
    topLight.position.set( 0, 1, 0 );
    @scene.add( topLight );

    leftLight = new THREE.DirectionalLight( 0xff0000, @leftIntensity );
    leftLight.position.set( 1, 0, 0 );
    @scene.add( leftLight );

    @frontLight = new THREE.DirectionalLight( 0xff0000, @frontInensity );
    @frontLight.position.set( 0, 0, 1 );
    @scene.add( @frontLight );

    bottomLight = new THREE.DirectionalLight( 0x0000ff, @bottomIntensity);
    bottomLight.position.set( 0, -1, 0 );
    @scene.add( bottomLight );

    rightLight = new THREE.DirectionalLight( 0x0000ff, @rightIntensity);
    rightLight.position.set( -1, 0, 0 );
    @scene.add( rightLight );

    backLight = new THREE.DirectionalLight( 0x0000ff, @backIntensity );
    backLight.position.set( 0, 0, -1 );
    @scene.add( backLight );

  __initGeometry:->
    #super
    @__buildingGeomety()


  __buildingGeomety: ->

    @geometry = new THREE.BoxGeometry( 20, 20, 20 )
    @material = new THREE.MeshLambertMaterial( { color: 0xffffff } )

    @mesh = new THREE.Mesh( @geometry, @material )
    @mesh.position.y = 0
    @mesh.position.x = 0
    @scene.add(@mesh)
    @sceneObjs.push(@mesh)


  loop:->
    requestAnimationFrame =>
       @loop()
    @update()
    @render()

  render: ->
    @stats.begin()
    @composer.render()
    #@renderer.render( @scene, @camera )
    @stats.end()

  update: ->
    @__shaderUpdateForAudio()
    for mesh in @sceneObjs
      mesh.rotation.x += 0.01
      mesh.rotation.y += 0.02


  __shaderUpdateForAudio: ->
    freqArr = @audioStream.update()
    if freqArr isnt 0
      @__updateVerticalShader(freqArr)
      @__updateHorizontalShader(freqArr)

  __updateVerticalShader:(freq) ->
      avg = (freq[0]+freq[1]+freq[2])/3
      percent = (avg*@Vrange)/@AudioMax;
      unival = @Vmin + percent
      @Veffect.uniforms[ 'v' ].value = unival

  __updateHorizontalShader:(freq) ->
      avg = (freq[3]+freq[4]+freq[5])/3
      percent = (avg*@Hrange)/@AudioMax;
      unival = @Hmin + percent
      @Heffect.uniforms[ 'h' ].value = unival


module.exports = AudioShaderDemo
