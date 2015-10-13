@exportsReady = () ->
  if $('[data-object~="ajax-timer"]').length > 0
    interval = setInterval( () ->
      $('[data-object~="ajax-timer"]').each( () ->
        $.post($(this).data('path'), "interval=#{interval}", null, "script")
      )
    , 5000)

$(document)
  .on('click', '[data-object~="toggle-delete-buttons"]', () ->
    $($(this).data('target-show')).show()
    $($(this).data('target-hide')).hide()
    false
  )
