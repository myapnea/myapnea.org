@navigationUXReady = () ->

  $("#container-left")
    .removeClass "no-js"
    .addClass "js"
  $("#container-right")
    .removeClass "no-js"
    .addClass "js"

  $(".hover-slide-left").mouseenter ->
    $(this).filter(':not(:animated)').animate width: "100%", 150
    return
  $(".hover-slide-left").mouseleave ->
    $(this).animate width: "95%", 150
    return

  $(".share-icons-animate").mouseenter ->
    $(this).filter(':not(:animated)').animate boxShadow: "0 3px 10px #888", top: "-5px", 150
    return
  $(".share-icons-animate").mouseleave ->
    $(this).animate boxShadow: "0 3px 5px #888", top: "0px", 150
    return

  $('.navbar-toggle').click ->
    $('#container-right, #container-left, .navbar-toggle, #container_main').toggleClass "active-sidebar"
  $(window).resize ->
    $('#container-right, #container-left, .navbar-toggle, #container_main').removeClass "active-sidebar"

  # navbarToggle = false
  # $('.navbar-toggle').click ->
  #   if navbarToggle
  #     $('#container-right-notfixed #container-left, .navbar-toggle').toggleClass "slide-active"
  #     $('#container-right').animate left: "100%", width: "20%", 150
  #     # $('#container-left').animate right: "0%", 150
  #     $('.navbar').animate right: "0%", 150
  #     $('.navbar-brand').animate left: "0px", 150, ->
  #       $('.navbar-brand, nav').toggleClass "slide-active"
  #       $('#social-backdrop').show()
  #       return
  #     navbarToggle = false
  #   else
  #     $('#social-backdrop').hide()
  #     $('#container-right-notfixed #container-left, .navbar-toggle, nav, .navbar-brand').toggleClass "slide-active"
  #     $('#container-right').animate left: "40%", width: "60%", 150
  #     # $('#container-left').animate right: "65%", 150
  #     $('.navbar-brand').animate left: "-400px", 150
  #     $('.navbar').animate right: "60%", 150
  #     navbarToggle = true
  #   return

  # $(window).resize ->
  #   if $(window).width() < 767 and navbarToggle
  #     console.log "Back to browswer!"
  #     $('#container-right-notfixed #container-left, .navbar-toggle').toggleClass "slide-active"
  #     $('#container-right').animate left: "100%", width: "20%", 150
  #     # $('#container-left').animate right: "0%", 150
  #     $('.navbar').animate right: "0%", 150
  #     $('.navbar-brand').animate left: "0px", 150, ->
  #       $('.navbar-brand, nav, ').toggleClass "slide-active"
  #       $('#social-backdrop').show()
  #       return
  #     navbarToggle = false
  #   return

