@onFinish2 = (id) ->
  $(".full-video-frame").click()

$(document)
  .on("click touchstart", ".full-video-frame", ->
    $("#shade").fadeOut()
    $(".full-video-frame").removeClass("d-flex")
    $("body").removeClass("noscroll")
    $(".full-video-frame iframe").attr("src", "")
    false
  )
  .on("click", "[data-object~=launch-full-page-video]", ->
    $("body").addClass("noscroll")
    $("#shade").fadeIn()
    $(".full-video-frame").addClass("d-flex")
    url = $(this).data("video-src") || ""
    $(".full-video-frame iframe").attr("src", url)
    iframe = $(".full-video-frame iframe")[0]
    # player = $f(iframe)
    # player.addEvent("ready", ->
    #   player.addEvent("finish", onFinish2)
    # )
    false
  )
  .on("click", "[data-object~=launch-full-page-video], .full-video-frame", ->
    false
  )
