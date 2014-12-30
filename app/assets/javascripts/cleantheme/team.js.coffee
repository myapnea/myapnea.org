@teamReady = () ->
  $(".team-member-picture").hover ->
    $(this).toggleClass "img-bw"
    $(this).toggleClass "img-bw-partial"
    return

  $(".team-member-picture").click ->
    $(".team-member-picture").removeClass "img-color"
    $(this).toggleClass "img-color"
    return
