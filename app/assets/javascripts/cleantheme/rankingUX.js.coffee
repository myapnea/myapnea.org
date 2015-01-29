# voting icon, progress bar
# voting icon is .voted if user voted, .disabled if user did not vote
# progress bar is .collapse.in if user voted, .collapse if user did not vote
@hideRankBar = (element1, element2) ->
  $(element1).animate
    color: "rgba(0,0,0,.8)"
    ,400
    , ->
      $(element1).removeClass "voted"
      $(element1).addClass "disabled"
      $(element2).find(".progress-bar").width 0 + "%"
      $(element2).find(".progress-bar").html 0 + "%"
      $(element2).removeClass "in"


@showRankBar = (element1, element2, voted) ->
  if voted
    $(element1).animate
      color: "rgb(89, 153, 222)"
      ,400
      , ->
        newWidth = parseFloat($(element2).find(".progress-bar").attr("aria-valuenow"))
        $(element1).removeClass "disabled"
        $(element1).addClass "voted"
        $(element2).addClass "in"
        $(element2).find(".progress-bar").width newWidth + "%"
        $(element2).find(".progress-bar").html newWidth + "%"
  else
    unless $(element2).hasClass "in"
      $(element1).animate
        color: "rgba(0,0,0.8)"
        ,100
        , ->
          newWidth = parseFloat($(element2).find(".progress-bar").attr("aria-valuenow"))
          $(element2).addClass "in"
          $(element2).find(".progress-bar").width newWidth + "%"
          $(element2).find(".progress-bar").html newWidth + "%"
          userHasNoVotes(element2)
  return

@userHasNoVotes = (element) ->
  alert = "<div class='alert alert-danger', style='width:90%;'> You have used all of your votes! Come back tomorrow to vote more.</div>"
  $(element).before alert



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
    $(this).find(".progress-bar").width currentProgress + "%"
    return
