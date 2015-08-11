$(document)
  .on('change', '#survey_pediatric', () ->
    if $(this).prop('checked')
      $("[data-object~='show-for-pediatric']").show()
    else
      $("[data-object~='show-for-pediatric']").hide()
  )
