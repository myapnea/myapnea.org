@fadeAndRemove = (element) ->
  $(element).fadeOut(500, -> $(element).remove())

@consentReady = ->
  $("#consent .scroll").slimscroll(
    height: '385px'
    alwaysVisible: true
    railVisible: true
  )

  $("a#print-link").click ->
    $("div#print-area").printArea()
    false

@setFocusToField = (element_id) ->
  val = $(element_id).val()
  $(element_id).focus().val('').val(val)

@extensionsReady = ->
  datepickerReady()
  fileDragReady()
  notouchReady()
  tooltipsReady()

@objectsReady = ->
  repliesReady()

# These functions get called on initial page visit and on turbolink page changes
@turbolinksReady = ->
  extensionsReady()
  objectsReady()
  # TODO: Organize Other Ready functions
  consentReady()
  teamReady()
  questionsReady() if questionsReady?
  landingReady() if landingReady?
  mapsReady()
  shareIconsReady() if shareIconsReady?
  drawSurveyProgressReady() if drawSurveyProgressReady?
  surveyAnimationReady() if surveyAnimationReady?
  registrationUXReady() if registrationUXReady?
  validationReady() if validationReady?
  toolsReady() if toolsReady?
  surveyReportsReady() if surveyReportsReady?
  fileDragOldReady()
  exportsReady()
  socialMediaReady() if $('#sleep_tip').length > 0
  builderQuestionsReady()
  builderAnswerTemplatesReady()
  builderAnswerOptionsReady()
  mapsReady()
  landingReadyNew()
  animateProgressBar()

# These functions only get called on the initial page visit (no turbolinks).
# Browsers that don't support turbolinks will initialize all functions in
# turbolinks on page load. Those that do support Turbolinks won't call these
# methods here, but instead will wait for `turbolinks:load` event to prevent
# running the functions twice.
@initialLoadReady = ->
  turbolinksReady() unless Turbolinks.supported

$(document).ready(initialLoadReady)
$(document)
  .on('turbolinks:load', turbolinksReady)
  .on('click', '[data-object~="submit"]', ->
    $($(this).data('target')).submit()
    false
  )
  .on('click', '[data-object~="suppress-click"]', ->
    false
  )
