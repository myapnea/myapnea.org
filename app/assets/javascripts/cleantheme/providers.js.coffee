@providersReady = () ->
  $("#video-play").mouseleave ->
    $(this).children("i").animate
      backgroundColor: "rgba(250,250,250,.43)"
      , 300
    return

  $("#video-play").mouseenter ->
    $(this).children("i").animate
      backgroundColor: "#FFA400"
      , 300
    return
