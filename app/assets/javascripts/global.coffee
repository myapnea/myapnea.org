@fadeAndRemove = (element) ->
  $(element).fadeOut(500, -> $(element).remove())

@setFocusToField = (element_id) ->
  val = $(element_id).val()
  $(element_id).focus().val("").val(val)

@extensionsReady = ->
  datepickerReady()
  fileDragReady()
  tooltipsReady()

@componentsReady = ->
  animateProgressBar()
  chartsReady()
  progressReady()
  themesReady()

@objectsReady = ->
  repliesReady()
  teamMembersSort()

# These functions get called on initial page visit and on turbolink page changes
@turbolinksReady = ->
  componentsReady()
  extensionsReady()
  objectsReady()

# These functions only get called on the initial page visit (no turbolinks).
# Browsers that don't support turbolinks will initialize all functions in
# turbolinks on page load. Those that do support Turbolinks won't call these
# methods here, but instead will wait for `turbolinks:load` event to prevent
# running the functions twice.
@initialLoadReady = ->
  turbolinksReady() unless Turbolinks.supported

$(document).ready(initialLoadReady)
$(document)
  .on("turbolinks:load", turbolinksReady)
  .on("click", "[data-object~=submit]", ->
    $($(this).data("target")).submit()
    false
  )
  .on("click", "[data-object~=submit-and-disable]", ->
    disablerWithSpinner($(this))
    $($(this).data("target")).submit()
    false
  )
  .on("click", "[data-object~=suppress-click]", ->
    false
  )
