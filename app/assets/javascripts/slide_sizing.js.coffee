@slidesReady = () ->
  winH = 800 # $(window).height()
  navH = $('nav').height()
  $('.row-fullscreen').height(winH - navH)
  $('#slide-1').css('margin-top', navH)
