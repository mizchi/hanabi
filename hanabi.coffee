{PI} = Math

do (w = window, r = 'equestAnimationFrame') ->
  w['r'+r] = w['r'+r] || w['webkitR'+r] || w['mozR'+r] || w['msR'+r] || w['oR'+r] || (c) -> w.setTimeout c, 1000 / 60

clearPoint = (ctx, x, y, size) ->
  requestAnimationFrame ->
    ctx.save()
    ctx.beginPath()
    ctx.arc(x, y, size*1.2, 0, PI*2, true)
    ctx.clip()
    ctx.clearRect(0, 0, @width, @height)
    ctx.restore()

class FireWorks
  constructor: ({
    @quantity
    @size
    @circle
    @gravity
    @speed
    @color
    @width
    @height
  } = {}) ->
    @quantity ?= 256 # particle　quantity
    @size     ?= 4.8 # particle size
    @circle   ?= 0.965 # size
    @gravity  ?= 1.2 # gravity
    @speed    ?= 7.8 # particle spped
    @color    ?= '#ffcc00' # particle color(#ffffff or rgba(255, 255, 255, 1) or black or random)

    @width  ?= 640
    @height ?= 480

    @canvas = document.createElement('canvas')
    @ctx = @canvas.getContext('2d')
    @canvas.width = 640
    @canvas.height = 480

    @particles = []
    @frame = 0
    for i in [0...@quantity]
      angle = Math.random() * PI * 2
      speed = Math.random() * @speed
      @particles.push
        centerX   : @width/2
        centerY   : @height/2
        velocityX : Math.cos(angle) * speed
        velocityY : Math.sin(angle) * speed

  dispose: ->
    delete @quantity
    delete @size
    delete @circle
    delete @gravity
    delete @speed
    delete @color
    delete @width
    delete @height
    delete @ctx
    @parent.removeChild(@canvas)
    delete @canvas
    @particles.length = 0
    delete @particles
    Object.freeze(@)

  appendTo: (query) ->
    @parent = document.querySelector(query)
    @parent.appendChild @canvas

  updateParticles: ->
    @particles.forEach (p, index) =>
      # clearPoint(ctx, s.centerX, s.centerY, hanabi.size)
      p.centerX += p.velocityX
      p.centerY += p.velocityY
      p.velocityX *= @circle
      p.velocityY *= @circle
      p.centerY += @gravity

      if @size > 0.1 and 0 < p.centerX < @width and 0 < p.centerY < @height
        ''
      else
        @particles.splice @particles.indexOf(p), 1

  drawParticles: ->
    @ctx.fillStyle =
      if @frame % 2
        "rgba(256, 256, 256, 0.8)"
      else @color

    @particles.forEach (p, index) =>
      @ctx.beginPath()
      @ctx.arc p.centerX, p.centerY, @size, 0, PI * 2, true
      @ctx.fill()

  render: =>
    unless @particles.length
      @dispose()
      @onFinish?()
    @ctx.clearRect 0, 0, @width, @height
    @frame++
    @updateParticles()
    @drawParticles()

    @size *= @circle
    @ctx.fillStyle = 'rgba(0, 0, 0, 0.4)'
    requestAnimationFrame @render

window.addEventListener 'load', ->
  fw = new FireWorks
  fw.appendTo 'body'
  fw.render()

