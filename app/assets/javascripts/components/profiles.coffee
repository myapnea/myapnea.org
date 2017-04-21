$(document)
  .on('mouseenter', '[data-object~="change-text-on-hover"]', ->
    $(this).html($(this).data('text-hover'))
  )
  .on('mouseleave', '[data-object~="change-text-on-hover"]', ->
    $(this).html($(this).data('text-default'))
  )
