$(document)
  .on("click", "[data-object~=close-fullscreen-blog]", (event) ->
    return if event.target != this
    $(".blog-fullscreen-backdrop[data-broadcast-id=#{$(this).data("broadcast-id")}]").removeClass("d-flex")
    $("body").removeClass("noscroll")
    false
  )
  .on("click", "[data-object~=show-fullscreen-blog]", ->
    $("body").addClass("noscroll")
    $(".blog-fullscreen-backdrop[data-broadcast-id=#{$(this).data("broadcast-id")}]").addClass("d-flex")
    false
  )
