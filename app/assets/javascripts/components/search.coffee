$(document)
  .on('click', '[data-object~="show-search-bar"]', () ->
    $('.tiny-search-icon').hide()
    $('.full-search-bar').show()
    # $('.full-search-bar').animate(right: '93px')
    setFocusToField('#navigation-search')
    false
  )
  .on('blur', '#navigation-search-form', (e) ->
    # $('.full-search-bar').animate(right: '-200px', null, () ->
    #   $('.full-search-bar').hide()
    #   $('.tiny-search-icon').show()
    # )
    $('.full-search-bar').hide()
    $('.tiny-search-icon').show()
  )
  .on('mousedown', '#navigation-form-search-btn', () ->
    $('#navigation-search-form').submit() unless $('#navigation-search').val() == ''
    false
  )
