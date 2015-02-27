@validationReady = () ->

  # Initiate error catching
  if $("[data-object~='inline-validation']").length > 0
    errors = {}

  $("[data-object~='inline-validation'] [data-object~='inline-validation-item'] ").blur () ->
    # Dynamically update custom url name during registration process ONLY
    if $(this).data('name') == 'provider-name'
      $("[data-name~='provider-slug']").val $("[data-name~='provider-name']").val().replace(/[^\w]/g, "-").replace(/-+$/, "").toLowerCase()
      checkForBlank($("[data-name~='provider-slug']"))
    checkForBlank(this)
    if $(this).data('name') == 'provider-slug'
      checkSlug($(this))

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
      $("[data-object~='"+errorName+"']").removeClass "hidden"
      errors[errorName]=true
    else
      $("[data-object~='"+errorName+"']").addClass "hidden"
      errors[errorName]=false
    return

  @checkSlug = (element1) ->
    regexSlug = new RegExp("^[a-z0-9]+(-[a-z0-9]+)*$")
    errorName = 'provider-slug--error'
    if regexSlug.test($(element1).val())
      console.log "everything okay"
      $("[data-object~='"+errorName+"']").addClass "hidden"
      errors[errorName]=false
    else
      console.log "everything NOT okay"
      $("[data-object~='"+errorName+"']").removeClass "hidden"
      errors[errorName]=true
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


  ########## DATES ##########
  $("[data-validation~='inline-validation-date'] [data-object~='inline-validation-item']").blur (e) ->
    validationItem = $("[data-validation~='inline-validation-date'] [data-object~='inline-validation-item']")
    dateString = validationItem.val()
    errorMessage = validateDate(dateString)
    if validationItem.data('over18')
      errorMessage += validateOver18(dateString)
    if errorMessage != ''
      $("[data-object~='date--error']").removeClass("hidden")
      $("[data-object~='date--error-message']").html errorMessage
    else
      $("[data-object~='date--error']").addClass("hidden")


  @validateDate = (dateString) ->
    if dateString.length == 0
      return ""
    if(!/^\d{1,2}\/\d{1,2}\/\d{4}$/.test(dateString))
      return "incorrect format"

    parts = dateString.split("/")
    month = parseInt(parts[0], 10)
    day = parseInt(parts[1], 10)
    year = parseInt(parts[2], 10)

    if (year < 1900 or year > 2015)
      return "Invalid year. "
    if (month < 1 or month > 12)
      return "Invalid month. "

    monthLength = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
    if (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))
        monthLength[1] = 29

    unless (day > 0 && day <= monthLength[month - 1])
      return "Invalid date. "

    return ""

  @validateOver18 = (dateString) ->
    parts = dateString.split("/")
    month = parseInt(parts[0], 10)
    day = parseInt(parts[1], 10)
    year = parseInt(parts[2], 10)

    birthDate = new Date(year, month-1, day)
    minimumDate = new Date(year+18, month-1, day)
    todaysDate = new Date()

    if minimumDate > todaysDate
      return "You must be over 18 to join MyApnea.Org."
    return ""









