$(document)
  .on('click', "[data-object~='show-todays-users']", (event) ->
    $('.todays-users').toggleClass 'great-bcg'
  )
  .on('click', "[data-object~='show-this-weeks-users']", (event) ->
    $('.this-weeks-users').toggleClass 'good-bcg'
  )
