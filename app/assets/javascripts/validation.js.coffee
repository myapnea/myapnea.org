@validationReady = () ->

  # Initiate error catching
  if $("[data-object~='inline-validation']").length > 0
    errors = {}

  $("[data-object~='inline-validation'] [data-object~='inline-validation-item'] ").blur () ->
    # Dynamically update custom url name during registration process ONLY
    if $(this).data('name') == 'provider-name'
      $("[data-name~='provider-slug']").val $("[data-name~='provider-name']").val().replace(/ /g, "-")
      checkForBlank($("[data-name~='provider-slug']"))
    checkForBlank(this)

  # Catch errors on submission
  $("[data-object~='inline-validation']").submit (e) ->
    checkForBlanks()
    if countErrors() > 0
      e.preventDefault()
      alert("Please complete all fields before entering!")

  ######## METHODS ########
  @checkForBlank = (element1) ->
    errorName = $(element1).data('name') + '--error'
    if $(element1).val() == ''
      $("[data-object~='"+errorName+"']").removeClass("hidden")
      errors[errorName]=true
    else
      $("[data-object~='"+errorName+"']").addClass("hidden")
      errors[errorName]=false
    return

  @checkForBlanks = () ->
    validationItems = $("[data-object~='inline-validation'] [data-object~='inline-validation-item']")
    validationItems.each (index) ->
      checkForBlank(validationItems[index])
    return

  @countErrors = () ->
    errorCount = 0
    for type of errors
      if errors[type]
        errorCount += 1
    return errorCount



  ########## CHECKLISTS ##########
  # Handle things differently for single checklist items
  $("[data-object~='inline-validation-checklist']").submit (e) ->
    errors = {}
    validationItems = $("[data-object~='inline-validation-checklist'] [data-object~='inline-validation-item']")
    validationItems.each (index) ->
      checkboxName = $(validationItems[index]).data('name')
      errors[checkboxName] = !($(validationItems[index]).prop "checked")
      return
    # Here, we want the 'number of errors' (aka the number of blanks) to be less than the number of validationItems
    if validationItems.length > countErrors()
      return
    else
      e.preventDefault()
      alert "Please select at least one option!"
    return
