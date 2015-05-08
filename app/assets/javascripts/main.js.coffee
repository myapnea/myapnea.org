if typeof Turbolinks isnt 'undefined' and Turbolinks.supported
  Turbolinks.enableProgressBar();

@mainLoader = () ->
  $("select[rel=chosen]").chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '100%'
  $(".chosen").chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '100%'
#  $("#consent-link").popover(
#    content: "Click here to sign a consent form and unlock all the research features."
#    trigger: 'hover, focus'
#  )
#  $("#social-profile-link").popover(
#    content: "Click here to create a social profile and contribute to the community."
#    trigger: 'hover, focus'
#  )

  $(document.links).filter(() ->
    return this.hostname != window.location.hostname
  ).attr('target', '_blank')

  # Offcanvas
  $("[data-toggle=\"offcanvas-left\"]").click ->
    $(".row-offcanvas").toggleClass "active-left"
    $(".offcanvas-toggle a").toggleClass "active"
    return

  $("[data-toggle=\"offcanvas-right\"]").click ->
    $(".row-offcanvas").toggleClass "active-right"
    $(".offcanvas-toggle a").toggleClass "active"
    return

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

@loaders = () ->
  mainLoader()
  consentReady()
  surveysReady()
  rankingUXReady() if rankingUXReady?
  teamReady() if teamReady?
  providersReady() if providersReady?
  questionsReady() if questionsReady?
  landingReady() if landingReady?
  mapsReady() if mapsReady?
  navigationUXReady() if navigationUXReady?
  drawSurveyProgressReady() if drawSurveyProgressReady?
  videoControlsReady() if videoControlsReady?
  surveyAnimationReady() if surveyAnimationReady?
  registrationUXReady() if registrationUXReady?
  validationReady() if validationReady?
  toolsReady() if toolsReady?
  postsReady() if postsReady?
  surveyReportsReady() if surveyReportsReady?
  autocompleteGenderReady() if $("#user_gender").length > 0
  fileDragReady()

$(document).ready(loaders)
$(document)
  .on('page:load', loaders)
  .on('click', '[data-object~="login-with-focus"]', () ->
    setFocusToField("#user_email")
  )
