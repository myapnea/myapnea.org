# Scroll to active question
@nextQuestionScroll = (element2) ->
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
  $("body,html").animate
    scrollTop: newHeight, 400, 'swing'
  , ->
    changeFocus(element2)
    return

@changeFocus = (question) ->
  $("input").blur()
  $(question).find("input:not([type=hidden])").first().focus()

@setActive = (element) ->
  return false
  $(".survey-container.active").removeClass "active"
  $(element).addClass "active"

@assignQuestionDirect = (element) ->
  setActive(element)
  nextQuestionScroll($(".survey-container.active"))

# Progress to next or previous question
@assignQuestion = (next, prev) ->
  return false
  activeQuestion = $(".survey-container.active")
  if (next and activeQuestion.next().length) or (prev and activeQuestion.prev().length)
    activeQuestion.removeClass "active"
    if next
      activeQuestion.next().addClass "active"
    else if prev
      activeQuestion.prev().addClass "active"
    nextQuestionScroll($(".survey-container.active"))

#####################
# SURVEY SUBMISSION #
#####################

@checkCompletion = ->
  numberSelectors = $("[data-object~='survey-indicator']").length
  numberCompletedSelectors = $("[data-object~='survey-indicator'].complete").length + $("[data-object~='survey-indicator'].locked").length
  if $("[data-object~='date--error-message']").length > 0 and $("[data-object~='date--error-message']").html() != "" and !$("[data-object~='date--error']").hasClass("hidden")
    return false
  if numberSelectors == numberCompletedSelectors
    return true
  else
    return false

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
    nextQuestionScroll(newActiveQuestion)
  else if (next and !activeQuestion.nextAll().length)
    assignQuestion(true, false)
  else if (prev and !activeQuestion.prevAll().length)
    assignQuestion(false, true)

# Submit a survey answer
@submitAnswer = (inputElement) ->
  questionForm = inputElement.closest("form")
  $.post(questionForm.attr("action"), questionForm.serialize(), (data) ->
    indicator = $(questionForm).data('position')
    indicatorSelector = $("[data-object~='survey-indicator'][data-target~='#{indicator}']")
    if data['completed']
      indicatorSelector.removeClass 'incomplete'
      indicatorSelector.addClass 'complete'
      indicatorSelector.html "&#10003;"
    else
      indicatorSelector.removeClass 'complete'
      indicatorSelector.addClass 'incomplete'
      indicatorSelector.html Number(indicator) + 1
  , 'json')

@handleChangedValue = (inputElement) ->
  submitAnswer(inputElement)

@revealNextInput = (targetInput) ->
  $("[data-receiver~="+targetInput+"]").find("input").first().focus()

@surveyAnimationReady = ->
  # Initiate flow when survey is present
  if $("[data-object~='survey-introduction']").length > 0
    multiple_radios = $("[data-object~='radio-input-multiple']")
    multiple_radios.each (index) ->
      $(multiple_radios[index]).children($("[data-object~='radio-input-multiple-container']")).first().addClass('current')

$(document)
  # Handle 'prefer not to answer checkbox'
  .on('click', '.preferred-not-to-answer', ->
    checkbox = $(this).find('input:checkbox')
    checkbox.prop('checked', !checkbox.prop('checked'))
    handleChangedValue($(this))
    false
  )
  # Respond to radio clicks
  .on('click', '.survey-container input:radio', ->
    $(this).prop('checked', true) unless $(this).data('secondary')
    handleChangedValue($(this))
  )
  # Navigation for survey indicators
  .on('click', "[data-object~='survey-indicator']", (e) ->
    target = "question-container-#{$(this).data('target')}"
    nextQuestionScroll($("[data-object~='#{target}']"))
    false
  )
  # Submit survey
  .on('click', "[data-object~='survey-submit-btn']", ->
    if checkCompletion()
      params = {}
      params.answer_session_id = $(this).data('answer-session-id')
      $.post($(this).data('path'), params)
      $(this).addClass('hidden')
      $("[data-object~='survey-submit-congratulations-container']").removeClass('hidden')
      setActive($(this).parents('.survey-container'))
      nextQuestionScroll($(this).parents('.survey-container'))
    else
      $("[data-object~='survey-indicator'].incomplete").addClass('error')
      target = "question-container-#{$("[data-object~='survey-indicator'].incomplete").first().data('target')}"
      nextQuestionScroll($("[data-object~='#{target}']"))
    false
  )
  # Respond to click events on conditional events - note that this only works on checkbox inputs
  .on('click', "[data-object~='reveal-next-input']", ->
    if this.checked then revealNextInput($(this).data('target'))
  )

# Attach change event handler to everything but radio button inputs. Radio button inputs are changed by JS, so each time
# the :checked property is changed, handleChangedValue has to be called.
$(".survey-container input").not(":radio").change((event) ->
  target = event.target or event.srcElement
  handleChangedValue($(target))
)

$(".survey-container select").change((event) ->
  target = event.target or event.srcElement
  handleChangedValue($(target))
)
