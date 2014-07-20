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

class Hanabi
  constructor: ({
    @quantity
    @size
    @reduceRate
    @gravity
    @speed
    @color
    @width
    @height
    @x
    @y
    @parent
  } = {}) ->
    @quantity ?= 256 # particle　quantity
    @size     ?= 4.8 # particle size
    @reduceRate ?= 0.965 # size
    @gravity  ?= 1.2 # gravity
    @speed    ?= 7.8 # particle spped
    @color    ?= '#ffcc00' # particle color(#ffffff or rgba(255, 255, 255, 1) or black or random)

    @parent ?= 'body'
    @x ?= 0
    @y ?= 0
    @width  ?= 640
    @height ?= 480

    @canvas = document.createElement('canvas')
    @ctx = @canvas.getContext('2d')
    @canvas.width = 640
    @canvas.height = 480

    @canvas.style.position = 'absolute'
    @canvas.style.left = @x
    @canvas.style.top = @y

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
        size: @size
    @appendTo @parent

  dispose: ->
    delete @quantity
    delete @size
    delete @reduceRate
    delete @gravity
    delete @speed
    delete @color
    delete @width
    delete @height
    delete @ctx
    @parentEl.removeChild(@canvas)
    delete @canvas
    @particles.length = 0
    delete @particles
    Object.freeze(@)

  appendTo: (query) ->
    @parentEl = document.querySelector(query)
    @parentEl.appendChild @canvas

  updateParticles: ->
    @particles.forEach (p, index) =>
      # clearPoint(ctx, s.centerX, s.centerY, hanabi.size)
      p.centerX += p.velocityX
      p.centerY += p.velocityY
      p.velocityX *= @reduceRate
      p.velocityY *= @reduceRate
      p.centerY += @gravity
      p.size *= @reduceRate

      if p.size > 0.1 and 0 < p.centerX < @width and 0 < p.centerY < @height
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
      @ctx.arc p.centerX, p.centerY, p.size, 0, PI * 2, true
      @ctx.fill()

  fire: (cb) ->
    if cb then @cb ?= cb
    @render()

  render: (cb) =>
    unless @particles.length
      @dispose()
      @cb?()
      return
    @ctx.clearRect 0, 0, @width, @height
    @frame++
    @updateParticles()
    @drawParticles()

    @ctx.fillStyle = 'rgba(0, 0, 0, 0.4)'
    requestAnimationFrame @render

if module?.exports
  module.exports = Hanabi
else
  window.Hanabi = Hanabi

# window.addEventListener 'load', ->
#   r = Math.random
#   offsetX = 100
#   offsetY = 100
#   colors = [
#     '#ffcc00'
#     '#ff0000'
#     '#00ff00'
#     '#00ccff'
#     '#00ffcc'
#   ]

#   fire = (cb) ->
#     size = 450
#     x = $(window).width() * r()
#     y = $(window).height() * r() + $(window).scrollTop()

#     color = colors[~~(colors.length*r())]

#     fw = new Hanabi
#       width: size
#       height: size
#       x: x - size
#       y: y - size
#       color: color
#     fw.fire(cb)

#   do update = ->
#     fire(update)

#   $(document.body).on 'click', (ev) ->
#     fire()
