$(document)
  .on('click', '[data-object~="toggle-drawer"]', ->
    $('.drawer-and-shelf-container').toggleClass('drawer-open')
    false
  )
