if typeof Turbolinks isnt 'undefined' and Turbolinks.supported
  Turbolinks.enableProgressBar();

@mainLoader = () ->
  $(document.links).filter(() ->
    return this.hostname != window.location.hostname
  ).attr('target', '_blank')
  $('[data-toggle="tooltip"]').tooltip()

@consentReady = () ->
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

@loadDatepicker = () ->
  $('.datepicker').datepicker()

@loaders = () ->
  mainLoader()
  consentReady()
  teamReady()
  providersReady() if providersReady?
  questionsReady() if questionsReady?
  landingReady() if landingReady?
  mapsReady() if mapsReady?
  shareIconsReady() if shareIconsReady?
  drawSurveyProgressReady() if drawSurveyProgressReady?
  videoControlsReady() if videoControlsReady?
  surveyAnimationReady() if surveyAnimationReady?
  registrationUXReady() if registrationUXReady?
  validationReady() if validationReady?
  toolsReady() if toolsReady?
  postsReady() if postsReady?
  surveyReportsReady() if surveyReportsReady?
  autocompleteGenderReady() if $("#user_gender").length > 0
  fileDragOldReady()
  researchTopicsReady()
  dailyEngagementReady() if $(".daily-engagement-report").length > 0
  exportsReady()
  socialMediaReady() if $('#sleep_tip').length > 0
  engagementHeatmapReady() if $('.engagement-heatmap').length > 0
  builderQuestionsReady()
  builderAnswerTemplatesReady()
  builderAnswerOptionsReady()
  fileDragReady()
  loadDatepicker()
  topicsReady()

$(document).ready(loaders)
$(document)
  .on('page:load', loaders)
  .on('click', '[data-object~="submit"]', () ->
    $($(this).data('target')).submit()
    false
  )
  .on('click', '[data-object~="suppress-click"]', () ->
    false
  )
