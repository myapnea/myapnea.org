@onYouTubeIframeAPIReady = ->
  window.player = new (YT.Player)('player',
    videoId: '3I8YbWRgkjw'
    # videoId: 'M7lc1UVf-VE'
    playerVars:
      autoplay: 0
      loop: 0
      controls: 0
      rel: 0
      showinfo: 0
      autohide: 1
      modestbranding: 1
    events:
      'onReady': onPlayerReady
      'onStateChange': onPlayerStateChange)
  return

@onPlayerReady = (event) ->
  # event.target.playVideo()
  return

@onPlayerStateChange = (event) ->
  if event.data == YT.PlayerState.PLAYING and !window.done
    # setTimeout stopVideo, 6000
    window.done = true
  return

@stopVideo = ->
  window.player.stopVideo()
  return

@landingReady = ->
  tag = document.createElement('script')
  tag.src = 'https://www.youtube.com/iframe_api'
  firstScriptTag = document.getElementsByTagName('script')[0]
  firstScriptTag.parentNode.insertBefore tag, firstScriptTag
  window.player = undefined
  window.done = false

$(window).on("scroll", ->
  winTop = $(window).scrollTop()
  windowHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
  $(".scroll-down-arrow-visible").each ->
    pos = $(this).offset().top
    if pos - (windowHeight / 3) <= winTop
      $(this).addClass("scroll-down-arrow-invisible")
    else
      $(this).removeClass("scroll-down-arrow-invisible")
)

$(document)
  .on('click', "[data-object~='play-landing-video']", ->
    $('#video-slide').show()
    window.player.playVideo()
    false
  )
  .on('click', '#video-slide', ->
    if window.player.getPlayerState() == YT.PlayerState.PAUSED
      window.player.playVideo()
    else
      window.player.pauseVideo()
    false
  )
  .on('click', '[data-object~="pause-landing-video"]', ->
    window.player.pauseVideo()
    false
  )
  .on('click', "[data-object~='play-landing-video2']", ->
    $('.hide-me-video').hide()
    $('.show-me-video').show()
    window.player.playVideo()
    false
  )
  .on('click', "[data-object~='pause-landing-video2']", ->
    window.player.pauseVideo()
    $('.show-me-video').hide()
    $('.hide-me-video').show()
    false
  )
