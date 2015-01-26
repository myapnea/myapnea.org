@surveyAnimationReady = () ->

  # Initiate with focus on first question
  $(".survey-first-question").focus()

  # Scroll to active question
  @nextQuestionScroll = (element1, element2) ->
    currentHeight = element2.offset().top
    elementOffsetHeight = element2.outerHeight() / 2
    offsetHeight = $(window).outerHeight() / 2
    if elementOffsetHeight > offsetHeight
      newHeight = currentHeight - 91
    else
      newHeight = currentHeight - offsetHeight + elementOffsetHeight
    $("body").animate
      scrollTop: newHeight
    , 400
    , "swing"
    , ->
      console.log "Scrolled!"
      changeFocus(element1, element2)
      return

  # Change focus
  @changeFocus = (question1, question2) ->
    $(question1).find("input").blur()
    $(question2).find("input").focus()

  # Progress to next question
  @assignNextQuestion = () ->
    activeQuestion = $(".survey-container.active")
    if activeQuestion.next().length
      activeQuestion.removeClass "active"
      activeQuestion.next().addClass "active"
      newActiveQuestion = $(".survey-container.active")
      nextQuestionScroll(activeQuestion, newActiveQuestion)


  # Progress to next part in multiple-part question
  @assignNextMultipleQuestion = () ->
    activeQuestion = $(".multiple-question-container.current")
    if activeQuestion.next().length
      activeQuestion.removeClass "current"
      activeQuestion.next().addClass "current"
      newActiveQuestion = $(".multiple-question-container.current")
      nextQuestionScroll(activeQuestion, newActiveQuestion)
    else
      activeQuestion.removeClass "current"
      assignNextQuestion()


  # Respond to user clicking different questions
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
    if $(".survey-container.active").hasClass "progress-w-letter"
      inputs = $(".survey-container.active").find("input:radio")
      inputs.each (index) ->
        key = inputs[index].value.charCodeAt(0)
        if e.keyCode is key
          $(inputs[index]).prop "checked", true
          assignNextQuestion()
    if $(".survey-container.active").hasClass "progress-w-number"
      inputs = $(".survey-container.active .multiple-question-container.current").find("input:radio")
      inputs.each (index) ->
        key = inputs[index].value.charCodeAt(0)
        if e.keyCode is key
          $(inputs[index]).prop "checked", true
          assignNextMultipleQuestion()
    if $(".survey-container.active").hasClass "check-w-letter"
      inputs = $(".survey-container.active .input-container").find("input:checkbox")
      inputs.each (index) ->
        key = inputs[index].value.charCodeAt(0)
        if e.keyCode is key
          if $(inputs[index]).prop "checked"
            $(inputs[index]).prop "checked", false
          else
            $(inputs[index]).prop "checked", true


