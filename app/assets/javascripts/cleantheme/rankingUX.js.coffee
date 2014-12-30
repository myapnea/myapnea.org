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

    else
      $(this).animate
        color: "rgb(89, 153, 222)"

        # Adjust value and animate progress bar
        newWidth = parseFloat($(".progress-bar").attr("aria-valuenow")) + 1
        $(".progress-bar").width newWidth + "%"
        $(".progress-bar").html newWidth + "%"
    return
