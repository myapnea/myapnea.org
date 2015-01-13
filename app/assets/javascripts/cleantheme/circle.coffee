transform_styles = ['-webkit-transform', '-ms-transform', 'transform']

@drawSurveyProgress = (element) ->
  fill_rotation = ($(element).data('percent')/100)*180
  fix_rotation = fill_rotation*2
  for i in transform_styles
    $(element).find('.fill').css(i, 'rotate(' + fill_rotation + 'deg)')
    $(element).find('.mask.left').css(i, 'rotate(' + fill_rotation + 'deg)')
    $(element).find('.fill.fix').css(i, 'rotate(' + fix_rotation + 'deg)')

@drawSurveyProgressReady = () ->
  $("[data-object~='circle_percentage']").each( (index, element) ->
    drawSurveyProgress($(element))
  )
