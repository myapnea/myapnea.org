@navigationUXReady = () ->

  $("#container-main")
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
    $('.navbar-toggle, #container-main').toggleClass "active-sidebar"
  $(window).resize ->
    $('.navbar-toggle, #container-main').removeClass "active-sidebar"
