@animateProgressBar = ->
  $('[data-object~="progress-bar-animate"]').each((index, element) ->
    $(element).css('width') # Forces the animation to wait to be able to compute
    # the width of the element first before starting the animation.
    $(element).css('width', "#{$(element).data('percent')}%")
  )
