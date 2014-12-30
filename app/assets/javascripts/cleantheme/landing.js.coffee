@landingReady = () ->
  navH = $(".navbar").outerHeight()
  footerH = $(".footer").outerHeight()
  windowH = $(window).outerHeight()
  $("#container-left").css("min-height", windowH-footerH-navH)

  # Simplify by hard-setting the left-nav height
  $("#container-right").outerHeight(windowH-navH)

  # Set Recent News to be contained within main content
  headerPictureH = $("#user-profile-header-picture").outerHeight()
  headerTextH = $("#user-profile-header-text").outerHeight()
  profileH = $("#user-profile-container").outerHeight()
  containerLeftH = $("#container-left").outerHeight()
  recentNewsH = containerLeftH - profileH - headerPictureH - headerTextH - 20 - 30
  $("#recent-news").css("max-height", recentNewsH)
  $("#recent-news-container").outerHeight(recentNewsH)

  # console.log "success"

    # .on("[data-object~="hello"]", "click", () ->
    #   alert "hello"
    #   false
    # )

