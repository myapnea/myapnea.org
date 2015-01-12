@landingReady = () ->
  navH = $(".navbar").outerHeight()
  footerH = $(".footer").outerHeight()
  windowH = $(window).outerHeight()
  docH = $(document).outerHeight()
  # $("#container-left").css("min-height", windowH-footerH-navH)
  # $("#container-right").outerHeight(docH )
  containerLeftH = $("#container-left").outerHeight()
  containerRightFixedH = $('#container-right-fixed').outerHeight()
  $('#container-right-scroll').css('margin-top', containerRightFixedH)
  # $('#container-right-scroll').css('min-height', windowH-footerH-navH)

  # Fix for ie6-9 issues with placeholders
  $('input, textarea').placeholder()
