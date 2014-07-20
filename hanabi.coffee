# forked from Okada.Yusuke's "forked: fireworks" http:#jsdo.it/Okada.Yusuke/pj9W
# forked from kyo_ago's "fireworks" http:#jsdo.it/kyo_ago/fireworks
# forked from zarkswerk's "fireworx" http:#jsdo.it/zarkswerk/fireworx
# forked from zarkswerk's "fireworks" http:#jsdo.it/zarkswerk/3598

setTimeout ->
  hanabi =
    'quantity' : 256 # particle　quantity
    'size'     : 4.8 # particle size
    'circle'   : 0.965 # hanabi size
    'gravity'  : 1.2 # gravity
    'speed'    : 7.8 # particle spped
    'top'      : 3.6 # explosion point(top)
    'left'     : 2.1 # explosion point(left)
    'color'    : '#ffcc00' # particle color(#ffffff or rgba(255, 255, 255, 1) or black or random)

  rad = Math.PI * 2

  hibana = []
  cvs =
    'elem' : undefined    # canvas element
    'width' : 0    # canvas width(window max)
    'height' : 0    # canvas width(window height)
    'ctx' : undefined    # 2d context
    'left' : 0    # element offset(left)
    'top' : 0    # element offset(top)
    'pos_x' : 0    # explode point(x)
    'pos_y' : 0    # explode point(y)

  setTimeout ->
    cvs.pos_y = (cvs.height / hanabi.top) - cvs.top
    cvs.pos_x = cvs.width / hanabi.left - cvs.left
    for i in [0...hanabi.quantity]
      angle = Math.random() * rad
      speed = Math.random() * hanabi.speed
      hibana.push
        'pos_x' : cvs.pos_x
        'pos_y' : cvs.pos_y
        'vel_x' : Math.cos(angle) * speed
        'vel_y' : Math.sin(angle) * speed
    requestAnimationFrame(render)

  clear_point = (x, y, size) ->
    setTimeout ->
      requestAnimationFrame ->
        cvs.ctx.save()
        cvs.ctx.beginPath()
        cvs.ctx.arc(x, y, size*1.2, 0, rad, true)
        cvs.ctx.clip()
        cvs.ctx.clearRect(0, 0, cvs.width, cvs.height)
        cvs.ctx.restore()
    , 50

  frame = 0
  if hanabi.color is 'random'
    hanabi.color = colorz.randHsl(100, 90, 60, 50, 90, 70).toString()

  render = ->
    return unless hibana.length
    clear = 0
    frame++
    cvs.ctx.fillStyle = if frame % 2 then "rgba(256, 256, 256, 0.8)" else hanabi.color

    for s, index in hibana
      # clear_point(s.pos_x, s.pos_y, hanabi.size)
      s.pos_x += s.vel_x
      s.pos_y += s.vel_y
      s.vel_x *= hanabi.circle
      s.vel_y *= hanabi.circle
      s.pos_y += hanabi.gravity

      if hanabi.size < 0.1 or !s.pos_x or !s.pos_y or s.pos_x > cvs.width or s.pos_y > cvs.height
        hibana[i] = undefined
        if len < ++clear
          try
            window.parent.endAnimation(location.href)
          catch e
            {}
        return
      cvs.ctx.beginPath()
      cvs.ctx.arc(s.pos_x, s.pos_y, hanabi.size, 0, rad, true)
      cvs.ctx.fill()

    hanabi.size *= hanabi.circle
    cvs.ctx.fillStyle = 'rgba(0, 0, 0, 0.4)'
    cvs.ctx.fillRect(0, 0, cvs.width, cvs.height)
    requestAnimationFrame(render)

  cvs.elem = document.getElementById('hanabi')

  do ->
    b = document.body
    d = document.documentElement
    cvs.width = Math.max(b.clientWidth , b.scrollWidth, d.scrollWidth, d.clientWidth)
    cvs.height = Math.max(b.clientHeight , b.scrollHeight, d.scrollHeight, d.clientHeight)

  cvs.elem.height = cvs.height
  cvs.elem.width = cvs.width
  cvs.ctx = cvs.elem.getContext('2d')
  cvs.left =
    if cvs.elem.getBoundingClientRect
      cvs.elem.getBoundingClientRect().left
    else
      0
  cvs.top =
    if cvs.elem.getBoundingClientRect
      cvs.elem.getBoundingClientRect().top
    else
      0

#set window.requestAnimationFrame
do (w = window, r = 'equestAnimationFrame') ->
  w['r'+r] = w['r'+r] || w['webkitR'+r] || w['mozR'+r] || w['msR'+r] || w['oR'+r] || (c) -> w.setTimeout c, 1000 / 60
