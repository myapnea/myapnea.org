@teamReady = () ->
  body = $("html, body")
  top = $("#carousel-steering-committee").scrollTop() + 85

  $(".team-member-picture").hover ->
    $(this).toggleClass "img-bw"
    $(this).toggleClass "img-bw-partial"
    return

  $(".team-member-picture").click ->
    $(".team-member-picture").removeClass "img-color"
    $(this).toggleClass "img-color"
    swingToTop()
    return

  $(".advisory-small").click ->
    $(this).find(".collapse").collapse "toggle"
    console.log "collapsed"

  swingToTop = ->
    if ($(document).scrollTop() > top)
      $(body).stop().animate { scrollTop: top }, 500, 'swing'
    return
