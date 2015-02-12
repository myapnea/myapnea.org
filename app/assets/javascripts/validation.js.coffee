@validationReady = () ->

  # Initiate error catching
  if $("[data-object~='inline-validation']").length > 0
    errors = {}

  $("[data-object~='inline-validation'] [data-object~='inline-validation-item'] ").blur () ->
    # Dynamically update custom url name during registration process ONLY
    if $(this).data('name') == 'provider-name'
      $("[data-name~='provider-slug']").val $("[data-name~='provider-name']").val().replace(/ /g, "-")
      checkForError($("[data-name~='provider-slug']"))
    checkForError(this)

  # Catch errors on submission
  $("[data-object~='inline-validation']").submit (e) ->
    checkForErrors()
    if countErrors()
      e.preventDefault()
      alert("Please complete all fields before entering!")


  ######## METHODS ########
  @checkForError = (element1) ->
    errorName = $(element1).data('name') + '--error'
    if $(element1).val() == ''
      $("[data-object~='"+errorName+"']").removeClass("hidden")
      errors[errorName]=true
    else
      $("[data-object~='"+errorName+"']").addClass("hidden")
      errors[errorName]=false
    return

  @checkForErrors = () ->
    validationItems = $("[data-object~='inline-validation'] [data-object~='inline-validation-item']")
    validationItems.each (index) ->
      checkForError(validationItems[index])
    return

  @countErrors = () ->
    for type of errors
      if errors[type]
        return true
    return false
