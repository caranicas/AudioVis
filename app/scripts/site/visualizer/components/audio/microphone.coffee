class Microphone

  print:true
  count:0

  constructor: ->
    @context = new (window.AudioContext || window.webkitAudioContext)()
    navigator.getUserMedia = (navigator.getUserMedia ||  navigator.webkitGetUserMedia ||navigator.mozGetUserMedia || navigator.msGetUserMedia)
    navigator.getUserMedia({audio: true},@stream, @error)


  stream:(stream) =>
    input = @context.createMediaStreamSource(stream)
    @analyser = @context.createAnalyser()
    @analyser.fftSize = 32
    @analyser.minDecibels = -80
    @analyser.maxDecibels = -10
    @analyser.smoothingTimeConstant = 0.85
    bufferLength = @analyser.fftSize
    input.connect(@analyser)

  error:(e) =>
    console.error('Error getting microphone', e)
    @

  update: ->
    if @analyser?
      freqArray = new Uint8Array(@analyser.frequencyBinCount)
      timeArray = new Uint8Array(@analyser.frequencyBinCount)

      @analyser.getByteFrequencyData(freqArray)
      @analyser.getByteTimeDomainData(timeArray)

      if @print
        @print = false
        console.log('array',freqArray)

      ++@count

      if @count > 30
        @print = true
        @count = 0

      return freqArray
    else
      return 0



module.exports = Microphone
