@registrationUX = () ->
  $(".circle-progress").click ->
    circle = $(this)
    if circle.prev().hasClass "track-progress"
      circle.prev().animate
        backgroundColor: "#78c679", 400, ->
          circle.animate
            backgroundColor: "#78c679", 100, ->
              circle.addClass "viewed"
              circle.prev().addClass "viewed"

  # Show privacy modal on registration page
  if $("#introPrivacyModal").length > 0
    $("#introPrivacyModal").modal "show"
