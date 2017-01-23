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
  topicsReady()

@ready = ->
  extensionsReady()
  objectsReady()
  # TODO: Organize Other Ready functions
  consentReady()
  teamReady()
  providersReady() if providersReady?
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

$(document).ready(ready)
$(document)
  .on('turbolinks:load', ready)
  .on('click', '[data-object~="submit"]', ->
    $($(this).data('target')).submit()
    false
  )
  .on('click', '[data-object~="suppress-click"]', ->
    false
  )
