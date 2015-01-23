@surveyAnimationReady = () ->

  # Scroll to active question
  @nextQuestionScroll = (element) ->
    body = $("body")
    currentHeight = element.offset().top - 81 - 30
    addedHeight = element.outerHeight()
    newHeight = currentHeight + addedHeight
    body.animate
      scrollTop: currentHeight
    , 400
    , "swing"
    , ->
      console.log "Scrolled!"
      return

  # Progress to next question
  @assignNextQuestion = () ->
    activeQuestion = $(".survey-container.active")
    if activeQuestion.next().length
      activeQuestion.removeClass "active"
      activeQuestion.next().addClass "active"
      newActiveQuestion = $(".survey-container.active")
      nextQuestionScroll(newActiveQuestion)

  # Respond to user clicking on different options
  $('.survey-container').click (e) ->
    if $(e.target).hasClass "next-question"
      assignNextQuestion()
    else
      unless $(this).hasClass "active"
        activeQuestion = $(".survey-container.active")
        activeQuestion.removeClass "active"
        $(this).addClass "active"
        newActiveQuestion = $(".survey-container.active")
        if $(this).prev().length == 0
          console.log "clicked first question"
          $("body").animate
            scrollTop: 0
          , 400
          , "swing"
        else
          nextQuestionScroll(newActiveQuestion)

  # Respond to keystrokes
  $("body").keydown (e) ->
    if $(".survey-container.active").hasClass "progress-w-enter"
      if e.keyCode is 13
        assignNextQuestion()
    else if $(".survey-container.active").hasClass "progress-w-letter"
      inputs = $(".survey-container.active").find("input:radio")
      inputs.each (index) ->
        key = inputs[index].value.charCodeAt(0)
        if e.keyCode is key
          $(inputs[index]).prop "checked", true
          assignNextQuestion()


