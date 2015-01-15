@videoControlsReady = () ->

  iframe = $("#testframe")[0]
  player = $f(iframe)


  $(document)
    .on('click', "[data-object~='stop-video']", () ->
      player.api("pause")
    )
    .on('click', "[data-object~='play-video']", () ->
      player.api("play")
    )
