@landingReady = () ->
  # Fix for ie6-9 issues with placeholders
  $('input, textarea').placeholder()
