window.THREE = THREE = require 'threejs'
$ = require 'jquery'
Orbit = require 'orbitcontrols'
Stats  = require 'stats'

EffectComposer = require 'effectcomposer'
HorizontalShader = require 'horizontalblur'
VerticalShader = require 'verticalblur'


Mic = require './components/audio/microphone'
Mp3 = require './components/audio/mp3'

class AudioReactive

  size:100
  topIntensity:1
  leftIntensity:1
  frontIntensity:1
  bottomIntensity:1
  rightIntensity:1
  backIntensity:1


  AudioMax:255

  sceneObjs:[]
  debugging:false


  constructor: ->
    @info = arguments[0].info

    @HMax = @info.get('HMax')
    @VMax = @info.get('VMax')

    @XRot = @info.get('xRotation')
    @YRot = @info.get('yRotation')
    @ZRot = @info.get('zRotation')


    @debugging = arguments[0].debug
    window.addEventListener( 'resize', @__resize, false )

  init: ->
    @threeInit()
    @audioStream = new Mp3()

  threeInit: ->
    @__initScene()
    @__initRenderer()
    @__initCamera()
    @__initGeometry()
    @__initLights()

    if @debugging
      @__debugStats()
      @__initDat()

    @__initShader()
    @__createShaderEffects()

  __initScene: ->
    @scene = new THREE.Scene()

  __initRenderer: ->
    @webcan = $('#webgl-canvas')
    @renderer = new THREE.WebGLRenderer({canvas:@webcan[0]})
    @renderer.setSize( window.innerWidth, window.innerHeight )

  __initCamera: ->
    @camera = new THREE.PerspectiveCamera( 90, window.innerWidth / window.innerHeight, 1, 1000 )
    @camera.position.z = @size-(@size/3)
    #controls = new Orbit(@camera)

  __initGeometry:->
    @__axis() if @debugging
    @__buildingGeomety()

  __initLights: ->
    xColor = @info.get('xColor')
    yColor = @info.get('yColor')
    zColor = @info.get('zColor')
    topLight = new THREE.DirectionalLight( yColor, @topIntensity );
    topLight.position.set( 0, 1, 0 );
    @scene.add( topLight );

    leftLight = new THREE.DirectionalLight( xColor, @leftIntensity );
    leftLight.position.set( 1, 0, 0 );
    @scene.add( leftLight );

    @frontLight = new THREE.DirectionalLight( zColor, @frontInensity );
    @frontLight.position.set( 0, 0, 1 );
    @scene.add( @frontLight );

    bottomLight = new THREE.DirectionalLight( yColor, @bottomIntensity);
    bottomLight.position.set( 0, -1, 0 );
    @scene.add( bottomLight );

    rightLight = new THREE.DirectionalLight( xColor, @rightIntensity);
    rightLight.position.set( -1, 0, 0 );
    @scene.add( rightLight );

    backLight = new THREE.DirectionalLight( zColor, @backIntensity );
    backLight.position.set( 0, 0, -1 );
    @scene.add( backLight );

  __debugStats: ->
    @stats = new Stats()
    @stats.setMode(0)
    @stats.domElement.style.position = 'absolute'
    @stats.domElement.style.left = '0px'
    @stats.domElement.style.top = '0px'
    document.body.appendChild( @stats.domElement )

  __initDat: ->
    @dat = new dat.GUI()

  __initShader: ->
    @composer = new EffectComposer( @renderer )
    @composer.addPass( new EffectComposer.prototype.RenderPass( @scene, @camera ) )

  __createShaderEffects: ->
    @Heffect = new EffectComposer.prototype.ShaderPass(new HorizontalShader())
    @Heffect.uniforms[ "h" ].value = 0
    @composer.addPass(@Heffect)

    @Veffect = new EffectComposer.prototype.ShaderPass(new VerticalShader())
    @Veffect.renderToScreen = true;
    @Veffect.uniforms[ "v" ].value = 0
    @composer.addPass(@Veffect)

  __axis: ->
    axes = new THREE.AxisHelper(100)
    @scene.add( axes )

  __buildingGeomety: ->
    size = @info.get('shapeSize')
    count = @info.get('shapeCount')
    console.log('count', count)
    xBound = @info.get('XBound')
    yBound = @info.get('YBound')+1

    @geometry = new THREE.BoxGeometry( size, size, size )
    @material = new THREE.MeshLambertMaterial( { color: 0xffffff } )

    i = 0
    while(i < count)
      xpos = Math.floor(Math.random() * (xBound*2)) - xBound;
      ypos = Math.floor(Math.random() * (xBound*2)) - xBound;
      console.log (xpos)
      mesh = new THREE.Mesh( @geometry, @material )
      mesh.position.y = ypos
      mesh.position.x = xpos
      @scene.add(mesh)
      @sceneObjs.push(mesh)
      ++i

  __resize: =>
    @camera.aspect = window.innerWidth / window.innerHeight
    @camera.updateProjectionMatrix()
    @renderer.setSize( window.innerWidth, window.innerHeight )


  loop:->
    requestAnimationFrame =>
       @loop()
    @update()
    @render()

  render: ->
    if @debugging
      @stats.begin()
    #@renderer.render( @scene, @camera )
    @composer.render()
    if @debugging
      @stats.end()

  update: ->
    @__shaderUpdateForAudio()
    for mesh in @sceneObjs
      mesh.rotation.x += @XRot
      mesh.rotation.y += @YRot
      mesh.rotation.z += @ZRot

  __shaderUpdateForAudio: ->
    freqArr = @audioStream.update()
    if freqArr isnt 0
      @__updateVerticalShader(freqArr)
      @__updateHorizontalShader(freqArr)

  __updateVerticalShader:(freq) ->
    avg = (freq[0]+freq[1]+freq[2])/3
    percent = (avg*@VMax)/@AudioMax;
    @Veffect.uniforms[ 'v' ].value = percent

  __updateHorizontalShader:(freq) ->
    avg = (freq[3]+freq[4]+freq[5])/3
    percent = (avg*@HMax)/@AudioMax;
    @Heffect.uniforms[ 'h' ].value = percent


module.exports = AudioReactive
