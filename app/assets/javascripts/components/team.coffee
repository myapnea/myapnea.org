@teamReady = () ->
  body = $("html, body")
  top = $("#carousel-team").scrollTop() + 85

  $(".team-member-picture").hover ->
    $(this).toggleClass "img-bw"
    $(this).toggleClass "img-bw-partial"
    return

  $(".team-member-picture").click ->
    $(".team-member-picture").removeClass "img-color"
    $(this).toggleClass "img-color"
    swingToTop()
    return

  swingToTop = ->
    if ($(document).scrollTop() > top)
      $(body).stop().animate { scrollTop: top }, 500, 'swing'
    return
