$(document)
  .on("click", "[data-object~=select-username]", ->
    $("#user_username").val($(this).data("username"))
    $("#user_username").removeClass("is-invalid")
    false
  )
