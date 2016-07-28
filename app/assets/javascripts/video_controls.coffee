@stopYouTubeVideo = (element) ->
  $(element.data('target-iframe')).attr('src', '')

$(document)
  .on('click', "[data-object~='start-yt-video']", () ->
    $($(this).data('target-iframe')).attr('src', $(this).data('src'))
    false
  )
  .on('click', "[data-object~='stop-yt-video']", () ->
    stopYouTubeVideo($('#landing-video-play'))
    false
  )
  .on('hidden.bs.modal', "#landingVideoModal", (e) ->
    stopYouTubeVideo($('#landing-video-play'))
  )
