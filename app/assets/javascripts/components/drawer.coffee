$(document)
  .on('click touchstart', '[data-object~="toggle-drawer"]', ->
    $('.drawer-and-shelf-container').toggleClass('drawer-open')
    false
  )
