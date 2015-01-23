@surveyAnimationReady = () ->

  @nextQuestionScroll = (element) ->
    body = $("body")
    currentHeight = element.offset().top - 81 - 30
    addedHeight = element.outerHeight()
    newHeight = currentHeight + addedHeight
    body.animate
      scrollTop: newHeight
    , 400
    , "swing"
    , ->
      console.log "Scrolled!"
      return

  @assignNextQuestion = () ->
    activeQuestion = $(".survey-container.active")
    if activeQuestion.next().length
      activeQuestion.removeClass "active"
      activeQuestion.next().addClass "active"
      nextQuestionScroll(activeQuestion)

  $('.next-question').click ->
    assignNextQuestion()

  $("body").keydown (e) ->
    if e.keyCode is 13
      assignNextQuestion()
