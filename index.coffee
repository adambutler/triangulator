Canvas = require("canvas")
_ = require("lodash")
fs = require('fs')
resemble = require('node-resemble')

Image = Canvas.Image

width = 600
height = 300

canvas = new Canvas(width, height)

ctx = canvas.getContext("2d")

source = undefined
last = undefined
current = undefined

range = 100
times = 250

pointAX = undefined
pointAY = undefined
pointBX = undefined
pointBY = undefined

fs.readFile "source.jpg", (err, file) =>
  source = file
  init()

draw = ->
  last = current if current?

  backup = new Image();
  backup.src = canvas.toDataURL()

  ctx.fillStyle = _.sample(["#ffd350", "#ff4f97"])
  ctx.beginPath()

  startX = pointAX || _.random(0,width)
  startY = pointAY || _.random(0,height)

  secondX = pointBX || _.random(startX-range,startX+range)
  secondY = pointBY || _.random(startY-range,startY+range)

  lastX = _.random(secondX-range,secondX+range)
  lastY = _.random(secondY-range,startY+range)

  ctx.moveTo startX, startY
  ctx.lineTo secondX, secondY
  ctx.lineTo lastX, lastY
  ctx.closePath()
  ctx.fill()

  current = canvas.toBuffer()

  diff = resemble(source).compareTo(last).onComplete (lastData) ->
    diff = resemble(source).compareTo(current).onComplete (currentData) ->
      if lastData.misMatchPercentage < currentData.misMatchPercentage
        ctx.drawImage(backup, 0, 0, width, height)
      else
        # pointAX = secondX
        # pointAY = secondY
        # pointBX = lastX
        # pointBY = lastY

      if times == 0
        output()
      else
        times--
        draw()

  #
  #    {
  #      misMatchPercentage : 100, // %
  #      isSameDimensions: true, // or false
  #      getImageDataUrl: function(){}
  #    }
  #



output = ->
  fs.writeFile "index.html", "<img src='#{canvas.toDataURL()}'>", ->
    console.log "Complete"

init = ->
  ctx.fillStyle = "#fff"
  ctx.fillRect(0,0,width,height)

  current = canvas.toBuffer()
  draw()

# diff = resemble(file).compareTo(file2).ignoreColors().onComplete((data) ->
#   console.log data
#   return
# )


