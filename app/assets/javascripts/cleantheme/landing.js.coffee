@landingReady = () ->
  navH = $(".navbar").outerHeight()
  footerH = $(".footer").outerHeight()
  windowH = $(window).outerHeight()
  docH = $(document).outerHeight()
  $("#container-left").css("min-height", windowH-footerH-navH)

  # Simplify by hard-setting the left-nav height
  $("#container-right").outerHeight(docH )

  # Set Recent News to be contained within main content
  containerLeftH = $("#container-left").outerHeight()
  containerRightFixedH = $('#container-right-fixed').outerHeight()
  $('#container-right-scroll').css('margin-top', containerRightFixedH)
  $('#container-right-scroll').css('min-height', windowH-footerH-navH)


  # Fix for ie6-9 issues with placeholders
  $('input, textarea').placeholder()

  # console.log "success"

    # .on("[data-object~="hello"]", "click", () ->
    #   alert "hello"
    #   false
    # )

