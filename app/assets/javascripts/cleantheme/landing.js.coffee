@landingReady = () ->
  # containerRightFixedH = $('#container-right-fixed').outerHeight()
  # $('#container-right-scroll').css('margin-top', containerRightFixedH)

  # Fix for ie6-9 issues with placeholders
  $('input, textarea').placeholder()
