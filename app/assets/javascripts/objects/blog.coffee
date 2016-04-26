$(document)
  .on('click', '[data-object~="toggle-broadcast-comment"]', () ->
    $(this).closest('.broadcast-comment-header').siblings('.broadcast-comment-body').toggle()
    if $(this).html() == '[-]'
      $(this).html('[+]')
    else
      $(this).html('[-]')
    false
  )
