$(document)
  .on("click", "[data-object~=close-research-study]", (event) ->
    return if event.target != this
    $("[data-object~=research-study-backdrop][data-research-study~=\"#{$(this).data("research-study")}\"]").removeClass("d-flex")
    $("body").removeClass("noscroll")
    false
  )
  .on("click", "[data-object~=show-research-study]", ->
    $("body").addClass("noscroll")
    $("[data-object~=research-study-backdrop][data-research-study~=\"#{$(this).data("research-study")}\"]").addClass("d-flex")
    false
  )
