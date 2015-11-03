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

  drawCanvas = (canvasTypeId, canvasText) ->
    c = document.getElementById(canvasTypeId)
    ctx = c.getContext('2d')

    # Layout
    ctx.fillStyle = '#ffa400'
    ctx.fillRect 0, 0, 1000, 200
    ctx.fillStyle = '#5999de'
    ctx.fillRect 0, 200, 1000, 800
    ctx.fillStyle = '#fff'
    ctx.fillRect 0, 195, 1000, 10
    ctx.fillStyle = '#233063'
    ctx.fillRect 0, 700, 1000, 100

    # Title
    ctx.font = "100px 'Open Sans'"
    if canvasTypeId == 'sleepTipCanvas'
      canvasTitle = 'Sleep Tip'
    else if canvasTypeId == 'didYouKnowCanvas'
      canvasTitle = 'Did You Know?'
    ctx.fillStyle = '#fff'
    ctx.fillText canvasTitle, 50, 175

    # Content
    ctx.font = "40px 'Open Sans'"
    wrapText(ctx, canvasText, 50, 280, 700, 50)

    # Footer
    img = document.getElementById('logo')
    ctx.drawImage img, 465, 710
    ctx.font = "38px 'Open Sans'"
    ctx.fillText 'Learn more by visiting', 50, 757


  sleepTipText = $('#sleep_tip').val()
  drawCanvas('sleepTipCanvas', sleepTipText)

  didYouKnowText = $('#did_you_know').val()
  drawCanvas('didYouKnowCanvas', didYouKnowText)

  $(document)
    .on('input', '#sleep_tip', () ->
      tip = $(this).val()
      drawCanvas('sleepTipCanvas', tip)
    )
    .on('input', '#did_you_know', () ->
      tip = $(this).val()
      drawCanvas('didYouKnowCanvas', tip)
    )
