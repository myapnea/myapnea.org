@isNotInternetExplorer = () ->
  ua = window.navigator.userAgent
  msie = ua.indexOf("MSIE ")
  if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) # If Internet Explorer, return version number
    # parseInt(ua.substring(msie + 5, ua.indexOf(".", msie)))
    return false
  else # If another browser
    return true

@fileDragOldReady = () ->
  if window.FormData != undefined and isNotInternetExplorer()
    $("#filedrag").show()

$(document)
  .on('dragenter', '[data-object~="dropfile"]', (e) ->
    $(this).addClass('hover')
    e.stopPropagation()
    e.preventDefault()
  )
  .on('dragleave', '[data-object~="dropfile"]', (e) ->
    $(this).removeClass('hover')
    e.stopPropagation()
    e.preventDefault()
  )
  .on('dragover', '[data-object~="dropfile"]', (e) ->
    e.stopPropagation()
    e.preventDefault()
  )
  .on('drop', '[data-object~="dropfile"]', (e) ->
    $(this).removeClass('hover')
    e.stopPropagation()
    e.preventDefault()

    event = e.originalEvent || e
    file = event.dataTransfer.files[0]
    data = new FormData()
    data.append 'user[photo]', file

    $.ajax(
      url: root_url + 'update_account.js'
      type: 'PATCH'
      data: data         # The form with the file inputs.
      processData: false # Using FormData, no need to process data.
      contentType: false
    ).done( ->
      # console.log("Success: Files sent!")
    ).fail( ->
      # console.log("An error occurred, the files couldn't be sent!")
    )
  )
