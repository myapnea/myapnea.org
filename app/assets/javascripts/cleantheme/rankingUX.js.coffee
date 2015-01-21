@animateRankBar = (element1, element2) ->
  if $(element1).hasClass "voted"
    $(element1).animate
      color: "rgba(0,0,0,.8)"
      ,400
      , ->
        $(element1).removeClass "voted"
        $(element1).addClass "disabled"
        $(element2).find(".progress-bar").width 0 + "%"
        $(element2).find(".progress-bar").html 0 + "%"
        $(element2).removeClass "in"
  else if $(element1).hasClass "disabled"
    $(element1).animate
      color: "rgb(89, 153, 222)"
      ,400
      , ->
        newWidth = parseFloat($(element2).find(".progress-bar").attr("aria-valuenow"))
        console.log newWidth
        $(element1).removeClass "voted"
        $(element1).addClass "voted"
        $(element2).find(".progress-bar").width newWidth + "%"
        $(element2).find(".progress-bar").html newWidth + "%"

@rankingUXReady = () ->
  $(".expand-topic").click ->
    if $(this).html() is "Read more"
      $(this).html "Read less"
    else
      $(this).html "Read more"
    return

  # Load progress vars for things that users have already voted on
  $(".progress.in").each () ->
    currentProgress = parseFloat( $(this).find(".progress-bar").attr("aria-valuenow") )
    console.log currentProgress + 'on load'
    $(this).find(".progress-bar").width currentProgress + "%"
    return
