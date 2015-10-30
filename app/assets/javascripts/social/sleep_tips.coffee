@sleepTipsReady = () ->

  # Wraptext tutorial thanks to http://www.html5canvastutorials.com/tutorials/html5-canvas-wrap-text-tutorial/
  wrapText = (context, text, x, y, maxWidth, lineHeight) ->
    words = text.split(' ')
    line = ''
    n = 0
    while n < words.length
      testLine = line + words[n] + ' '
      metrics = context.measureText(testLine)
      testWidth = metrics.width
      if testWidth > maxWidth and n > 0
        context.fillText line, x, y
        line = words[n] + ' '
        y += lineHeight
      else
        line = testLine
      n++
    context.fillText line, x, y
    return

  drawSleepTip = (tipText) ->
    c = document.getElementById('sleepTipCanvas')
    ctx = c.getContext('2d')

    # Layout
    ctx.fillStyle = '#5999de'
    ctx.fillRect 0, 0, 1000, 200
    ctx.fillStyle = '#ffa400'
    ctx.fillRect 0, 200, 1000, 800
    ctx.fillStyle = '#fff'
    ctx.fillRect 0, 195, 1000, 10
    img = document.getElementById('logo')
    ctx.drawImage img, 490, 139

    # Title
    ctx.font = '100px Arial'
    ctx.fillText 'Sleep Tip', 50, 175

    # Content
    ctx.font = '40px Arial'
    wrapText(ctx, tipText, 50, 280, 700, 50)


  tipText = $('#sleep_tip').val()
  drawSleepTip(tipText)

  $(document)
    .on('input', '#sleep_tip', () ->
      tip = $(this).val()
      drawSleepTip(tip)
    )
