@surveyAnimationReady = () ->

  # Initiate with focus on first question
  if $(".survey-container").length
    $(document).ready ->
      $("#container-left").find(".survey-container").first().addClass "active"
      $(".survey-container.active").find("input:not([type=hidden])").first().addClass "survey-first-question"
      $(".survey-first-question").focus()
      return

  # Scroll to active question
  @nextQuestionScroll = (element1, element2) ->
    # Submit Previous Question
    if element2 is null
      return
    else
      # Check for multiple questions, and position the first question in the center
      if element2.find('.current').length > 0
        currentHeight = element2.find('.current').offset().top
        elementOffsetHeight = element2.find('.current').outerHeight() / 2
      else
        currentHeight = element2.offset().top
        elementOffsetHeight = element2.outerHeight() / 2
      offsetHeight = $(window).outerHeight() / 2
      # Check for large questions on small screens
      if elementOffsetHeight > offsetHeight
        newHeight = currentHeight - 91
      else
        newHeight = currentHeight - offsetHeight + elementOffsetHeight
      $("body").animate
        scrollTop: newHeight
      , 400
      , "swing"
      , ->
        changeFocus(element1, element2)
        return

  # Change focus
  @changeFocus = (question1, question2) ->
    $(question1).find("input").blur()
    $(question2).find("input").focus()

  @changeFocusDirect = (input1, input2) ->
    $(input1).blur()
    $(input2).focus()


  # Progress to next question
  @assignQuestion = (next, prev) ->
    activeQuestion = $(".survey-container.active")
    if (next and activeQuestion.next().length) or (prev and activeQuestion.prev().length)
      activeQuestion.removeClass "active"
      if next
        activeQuestion.next().addClass "active"
      else if prev
        activeQuestion.prev().addClass "active"
      newActiveQuestion = $(".survey-container.active")
      nextQuestionScroll(activeQuestion, newActiveQuestion)


  # Progress to next part in multiple-part question
  @assignMultipleQuestion = (next, prev) ->
    activeQuestion = $(".survey-container.active .multiple-question-container.current")
    if (next and activeQuestion.nextAll().length) or (prev and activeQuestion.prevAll().length)
      activeQuestion.removeClass "current"
      if next
        activeQuestion.nextAll(".multiple-question-container").first().addClass "current"
      else if prev
        activeQuestion.prevAll(".multiple-question-container").first().addClass "current"
      newActiveQuestion = $(".survey-container.active .multiple-question-container.current")
      nextQuestionScroll(activeQuestion, newActiveQuestion)
    else if (next and !activeQuestion.nextAll().length)
      assignQuestion(true, false)
    else if (prev and !activeQuestion.prevAll().length)
      assignQuestion(false, true)



  # Submit a survey answer
  @submitAnswer = (inputElement) ->
    questionForm = inputElement.closest("form")
    $.post(questionForm.attr("action"), questionForm.serialize(), (data) ->
      return
    , 'json')

  @handleChangedValue = (inputElement) ->
    submitAnswer(inputElement)

  # Respond to click events on conditional events - note that this only works on checkbox inputs
  $(".reveal-next-input").click (e) ->
    changeFocusDirect($(this), $(this).nextAll('.hidden-input').first())

  # Respond to user clicking different questions
  $('.survey-container').click (event) ->
    # For click events on 'Next Question' button, just assign next question
    if $(event.target).hasClass "next-question"
      assignQuestion(true, false)
    else
      # Respond to input clicks on active questions
      if $(this).hasClass "active"
        if $(event.target).closest("label").prev("input").is(":radio")
          event.preventDefault()
          $(event.target).closest("label").prev("input").prop "checked", true
          handleChangedValue($(event.target).closest("label").prev("input"))
          if $(event.target).closest("label").prev("input").hasClass "reveal-next-input"
            targetInput = $(event.target).closest("label").prev("input")
            changeFocusDirect(targetInput, targetInput.nextAll('.hidden-input').first())
          else if $(this).find('.multiple-question-container').length and $(event.target).closest(".multiple-question-container").hasClass "current"
            assignMultipleQuestion(true,false)
          else
            assignQuestion(true, false)
      else
        # Use the clicked container, rather than calling the assignQuestion function
        activeQuestion = $(".survey-container.active")
        activeQuestion.removeClass "active"
        $(this).addClass "active"
        newActiveQuestion = $(".survey-container.active")
        if $(event.target).closest("label").prev("input").is(":radio")
          event.preventDefault()
          $(event.target).closest("label").prev("input").prop "checked", true
          handleChangedValue($(event.target).closest("label").prev("input"))
          nextQuestionScroll(newActiveQuestion, null)
        else
          if $(this).prev().length == 0
            $("body").animate
              scrollTop: 0
            , 400
            , "swing"
          else
            nextQuestionScroll(activeQuestion, newActiveQuestion)

  # Respond to keystrokes
  $("body").keydown (e) ->
    # Respond to keystrokes only for survey pages
    if $('.survey-container').length
      # Prevent default up and down
      if e.keyCode is 38 or e.keyCode is 40
        e.preventDefault()
      # Prevent default enter
      if e.keyCode is 13
        e.preventDefault()
      # Specifically targeting custom date input
      if $(".survey-container.active").find(".survey-text-date").is(":focus")
        if e.metaKey
          return
        else if e.keyCode is 13
          # enter key
          $(".survey-container.active").find(".survey-text-date").blur()
          return
        else if e.keyCode is 46 or e.keyCode is 8
          # delete key
          rewriteDatePlaceholder(e.keyCode)
          return
        else if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) is not -1) or (e.keyCode is 65 and e.ctrlKey is true) or (e.keyCode >= 35 and e.keyCode <= 40)
          return
        else if (/^[a-zA-Z]*$/.test(+String.fromCharCode(e.keyCode)))
          # prevent letter from returning
          e.preventDefault()
        else if (/^[0-9]{1,10}$/.test(+String.fromCharCode(e.keyCode)))
          # allow number to be written
          e.preventDefault()
          rewriteDatePlaceholder(e.keyCode)

  # Respond to completed keystrokes
  $("body").keyup (e) ->
    # Respond to completed keystrokes only for survey pages
    if $('.survey-container').length
      # don't allow key up on custom date input
      if $(".survey-container.active").find(".survey-text-date").is(":focus")
        return
      # containers that can progress with a number input
      if $(".survey-container.active").hasClass "multiple-question-parts"
        inputs = $(".survey-container.active .panel .multiple-question-container.current").find("input:radio")
        if e.keyCode is 38
          e.preventDefault()
          assignMultipleQuestion(false, true)
        else if e.keyCode is 40
          e.preventDefault()
          assignMultipleQuestion(true, false)
        else
          inputs.each (index) ->
            key = $(inputs[index]).data("hotkey").toString().charCodeAt(0)
            if e.keyCode is key
              $(inputs[index]).prop "checked", true
              handleChangedValue($(inputs[index]))
              assignMultipleQuestion(true, false)
      else if e.keyCode is 38
        e.preventDefault()
        assignQuestion(false, true)
      else if e.keyCode is 40
        e.preventDefault()
        assignQuestion(true, false)
      # Respond to actual inputs
      else
        # Progress to next question for enter
        if $(".survey-container.active").hasClass "progress-w-enter"
          if e.keyCode is 13
            assignQuestion(true, false)
        # Progress to next question if applicable
        if $(".survey-container.active").hasClass "progress-w-hotkey"
          unless $(".survey-container.active .panel .hidden-input").is ":focus"
            inputs = $(".survey-container.active").find("input:radio")
            inputs.each (index) ->
              key = $(this).data("hotkey").toString().charCodeAt(0)
              if e.keyCode is key
                $(inputs[index]).prop "checked", true
                handleChangedValue($(inputs[index]))
                if $(inputs[index]).hasClass "reveal-next-input"
                    e.preventDefault()
                    changeFocusDirect($(this), $(this).nextAll('.hidden-input').first())
                else
                  assignQuestion(true, false)
        # Check answer option if applicable
        else if $(".survey-container.active").hasClass "check-w-hotkey"
          unless $(".survey-container.active .panel .hidden-input").is ":focus"
            inputs = $(".survey-container.active .panel .input-container").find("input:checkbox")
            inputs.each (index) ->
              key = $(inputs[index]).data("hotkey").toString().charCodeAt(0)
              if e.keyCode is key
                if $(inputs[index]).prop "checked"
                  $(inputs[index]).prop "checked", false
                  handleChangedValue($(inputs[index]))
                else
                  $(inputs[index]).prop "checked", true
                  handleChangedValue($(inputs[index]))
                if $(inputs[index]).hasClass "reveal-next-input"
                  e.preventDefault()
                  changeFocusDirect($(this), $(this).nextAll('.hidden-input').first())

  # Attach change event handler to everything but radio button inputs. Radio button inputs are changed by JS, so each time
  # the :checked property is changed, handleChangedValue has to be called.
  $("input").change (event) ->
    if $("input").parents(".survey-container").length
      handleChangedValue($(event.target))


  # Custom date input
  date_index = 0
  @rewriteDatePlaceholder = (keyCode) ->
    if keyCode is 8
      unless date_index is 0
        date_index -= 1
        currentPlaceholder = $(".survey-text-date").attr("placeholder")
        newPlaceholder = currentPlaceholder.slice(0, date_index)
        $(".survey-text-date").attr("placeholder", newPlaceholder)
    else
      unless date_index >= 10
        newKey = String.fromCharCode(keyCode)
        currentPlaceholder = $(".survey-text-date").attr("placeholder")
        if date_index == 2 or date_index == 5
          currentPlaceholder += '/'
          date_index += 1
        inputString = currentPlaceholder.slice(0,date_index) + newKey
        if date_index == 1 or date_index == 4
          inputString += '/'
          date_index += 1
        remainingString = currentPlaceholder.slice(date_index+1, currentPlaceholder.length)
        newPlaceholder = inputString + remainingString
        $(".survey-text-date").attr("placeholder", newPlaceholder)
        date_index += 1
