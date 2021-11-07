@themes = ->
  [
    "default"
    "default-dark"
    "dark-blue"
    "day"
    "sunset"
    "night"
  ]

@changeTheme = (theme) ->
  $("body").data("theme", theme)
  body_classes = themes().map (t) -> "theme-#{t}-bg"
  $(".theme-bg").removeClass(body_classes.join(" ")).addClass("theme-#{theme}-bg")

@randomTheme = ->
  index = Math.floor(Math.random() * themes().length)
  changeTheme(themes()[index])

@themesReady = ->
  if $("[data-object~=random-theme]").length > 0
    interval = setInterval( ->
      randomTheme()
    , 1000 * 1) # In one second
    removeInterval = ->
      clearInterval(interval)
      $(document).off("turbolinks:load", removeInterval)
    $(document).on("turbolinks:load", removeInterval)
