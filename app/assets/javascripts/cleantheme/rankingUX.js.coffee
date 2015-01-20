@rankingUXReady = () ->
  # UX for read more
  $(".expand-topic").click ->
    if $(this).html() is "Read more"
      $(this).html "Read less"
    else
      $(this).html "Read more"
    return

  # UX for thumbs up
  $(".fa-rank").click ->
    currentColor = $(this).css("color")
    #  If already clicked
    if currentColor is "rgb(89, 153, 222)"
      $(this).animate
        color: "rgba(0,0,0,.8)"
        ,400
        , ->
          $(".progress-bar").width 0 + "%"
          $(".progress-bar").html 0 + "%"
    else
      $(this).animate
        color: "rgb(89, 153, 222)"
        ,400
        , ->
          newWidth = parseFloat($(".progress-bar").attr("aria-valuenow")) + 1
          console.log newWidth
          $(".progress-bar").width newWidth + "%"
          $(".progress-bar").html newWidth + "%"
    return
