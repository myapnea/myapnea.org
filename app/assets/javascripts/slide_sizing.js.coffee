@slidesReady = () ->
  winH = 700 # $(window).height()
  navH = $('nav').height()
  # $('.row-fullscreen').height(winH - navH)
  $('#slide-1').css('margin-top', navH)
  $('#slide-1').height(800);
