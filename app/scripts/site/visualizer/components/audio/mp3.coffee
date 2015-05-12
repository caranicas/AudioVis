class Mp3

  print:true
  count:0

  constructor: ->
    @context = new AudioContext()# (window.AudioContext || window.webkitAudioContext)()
    @audio = document.getElementById('myAudio');
    @stream()

  stream: ->
    input = @context.createMediaElementSource(@audio)
    @analyser = @context.createAnalyser()
    @analyser.fftSize = 32
    @analyser.minDecibels = -80
    @analyser.maxDecibels = -10
    @analyser.smoothingTimeConstant = 0.85
    bufferLength = @analyser.fftSize
    input.connect(@analyser)
    input.connect(@context.destination);
    @audio.play()

  update: ->
    if @analyser?
      freqArray = new Uint8Array(@analyser.frequencyBinCount)
      timeArray = new Uint8Array(@analyser.frequencyBinCount)

      @analyser.getByteFrequencyData(freqArray)
      @analyser.getByteTimeDomainData(timeArray)

      #@print()

      return freqArray
    else
      return 0

  print: ->
    if @print
      @print = false
      console.log('array',freqArray)

    ++@count

    if @count > 30
      @print = true
      @count = 0


module.exports = Mp3
