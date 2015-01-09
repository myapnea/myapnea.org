@navigationUXReady = () ->
  $(".hover-slide-left").mouseenter ->
    $(this).filter(':not(:animated)').switchClass "list-shrink", "list-expand", 150
    return
  $(".hover-slide-left").mouseleave ->
    $(this).switchClass "list-expand", "list-shrink", 150
    return

  $(".share-icons-animate").mouseenter ->
    $(this).filter(':not(:animated)').animate boxShadow: "0 3px 10px #888", top: "-5px", 150
    return
  $(".share-icons-animate").mouseleave ->
    $(this).animate boxShadow: "0 3px 5px #888", top: "0px", 150
    return
  # Navigation hover
  # $("#testnavbar").children("li").mouseenter ->
  #   $(this).animate borderBottomColor: "#5999de", 150
  #   $(this).animate borderBottomWidth: "5px", 150
  #   return
  # $("#testnavbar").children("li").mouseleave ->
  #   unless $(this).hasClass("active")
  #     $(this).animate borderBottomColor: "rgba(36,50,100,0)", 300
  #     $(this).animate borderBottomWidth: "-5px", 300
  #   return

  navbarToggle = false
  $('.navbar-toggle').click ->
    if navbarToggle
      $('#container-right').animate left: "100%", 150
      $('#container-left').animate right: "0%", 150
      navbarToggle = false
    else
      $('#container-right').animate left: "40%", width: "60%", 150
      $('#container-left').animate right: "65%", 150
      navbarToggle = true

  # $(window).resize ->
  #   if $(window).width > 767 and $(".navbar-toggle") is ":hidden"
  #     $(selected).removeClass "slide-active"

  # # Mobile navigation
  # $("#slide-nav.navbar-inverse").after ->
  #   $("<div class='inverse' id='navbar-height-col'></div>")
  #   return

  # $("#slide-nav.navbar-default").after ->
  #   $("<div id='navbar-height-col'></div>")
  #   return

  # toggler = ".navbar-toggle"
  # pageWrapper = "#page-content"
  # navigationWrapper = ".navbar-header"
  # menuWidth = "100%"
  # slideWidth = "80%"
  # menuNeg = "-100%"
  # slideNeg = "-80%"

  # $("#slide-nav").click ->
  #   console.log "clicked!"
  #   selected = $(this).hasClass("slide-active")
  #   console.log selected

  #   $("#slidemenu").filter(':not(:animated)').animate left: selected ? menuNeg : "0px"
  #   $("#navbar-height-col").filter(':not(:animated)').animate  left: selected ? slideNeg : "0px"
  #   $(pageWrapper).stop().animate left: selected ? "0px" : slideWidth
  #   $(navigationWrapper).filter(':not(:animated)').animate left: selected ? "0px" : slideWidth

  #   $(this).toggleClass "slide-active", !selected
  #   $("#slidemenu").toggleClass "slide-active"

  #   $("#page-content, body, .navbar-toggle").toggleClass "slide-active"
  #   return
  # #   return

  # # selected = "slide-menu, #page-content, body, .navbar, .navbar-header"

