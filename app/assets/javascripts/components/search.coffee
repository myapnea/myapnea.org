$(document)
  .on('click', '[data-object~="show-search-bar"]', () ->
    $('.tiny-search-icon').hide()
    $('.full-search-bar').show()
    # $('.full-search-bar').animate(right: '93px')
    setFocusToField('#navigation-search')
    false
  )
  .on('blur', '#navigation-search', () ->
    # $('.full-search-bar').animate(right: '-200px', null, () ->
    #   $('.full-search-bar').hide()
    #   $('.tiny-search-icon').show()
    # )
    $('.full-search-bar').hide()
    $('.tiny-search-icon').show()
  )
