@landingReady = () ->

  if $('#container-right-notfixed').css('position') == 'fixed'
    containerRightFixedH = $('#container-right-fixed').outerHeight() or $('#container-right-notfixed').outerHeight()
  else
    containerRightFixedH = $('#container-right-fixed').outerHeight()
  $('#container-right-scroll').css('margin-top', containerRightFixedH)

  # Fix for ie6-9 issues with placeholders
  $('input, textarea').placeholder()
