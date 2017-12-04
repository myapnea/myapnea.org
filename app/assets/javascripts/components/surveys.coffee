@pad = (str, max) ->
  if !str then str = ""
  if str.length < max then pad("0" + str, max) else str

@clearClassStyles = (target_name) ->
  false

@clearDateFields = (element) ->
  target_name = element.data("target-name")
  clearClassStyles(target_name)
  $("##{target_name}_day").val("")
  $("##{target_name}_month").val("")
  $("##{target_name}_year").val("")
  $("##{target_name}_day").change()
  $("##{target_name}_day").blur()

@clearTimeFields = (element, time_of_day_format) ->
  target_name = element.data("target-name")
  clearClassStyles(target_name)
  $("##{target_name}_hours").val("")
  $("##{target_name}_minutes").val("")
  $("##{target_name}_seconds").val("")
  time_period = if time_of_day_format == '12hour-pm' then 'pm' else 'am'
  $("##{target_name}_period").val(time_period)
  $("##{target_name}_hours").change()
  $("##{target_name}_hours").blur()

@clearTimeDurationFields = (element) ->
  target_name = element.data("target-name")
  clearClassStyles(target_name)
  $("##{target_name}_hours").val("")
  $("##{target_name}_minutes").val("")
  $("##{target_name}_seconds").val("")
  $("##{target_name}_hours").change()
  $("##{target_name}_minutes").blur()

@setCurrentDate = (element) ->
  target_name = element.data("target-name")
  date = new Date()
  $("##{target_name}_day").val(date.getDate())
  $("##{target_name}_month").val(date.getMonth()+1)
  $("##{target_name}_year").val(date.getFullYear())
  $("##{target_name}_day").change()
  $("##{target_name}_day").blur()

@setCurrentTime = (element) ->
  currentTime = new Date()
  time =
    hours: pad(String(currentTime.getHours()), 2)
    minutes: pad(String(currentTime.getMinutes()), 2)
    seconds: pad(String(currentTime.getSeconds()), 2)

  target_name = element.data("target-name")
  date = new Date()
  $("##{target_name}_hours").val(time["hours"])
  $("##{target_name}_minutes").val(time["minutes"])
  $("##{target_name}_seconds").val(time["seconds"])
  $("##{target_name}_hours").change()
  $("##{target_name}_hours").blur()

@setCurrentTime12Hour = (element) ->
  currentTime = new Date()
  hour = currentTime.getHours() % 12
  hour = 12 if hour == 0
  time =
    hours: pad(String(hour), 2)
    minutes: pad(String(currentTime.getMinutes()), 2)
    seconds: pad(String(currentTime.getSeconds()), 2)
    period: if currentTime.getHours() < 12 then 'am' else 'pm'

  target_name = element.data("target-name")
  date = new Date()
  $("##{target_name}_hours").val(time["hours"])
  $("##{target_name}_minutes").val(time["minutes"])
  $("##{target_name}_seconds").val(time["seconds"])
  $("##{target_name}_period").val(time["period"])
  $("##{target_name}_hours").change()
  $("##{target_name}_hours").blur()

@toggleMutuallyExclusive = (element) ->
  group_name = "response[]"
  if $("input[name='#{group_name}'][data-mutually-exclusive=true]").length > 0
    if $(element).data("mutually-exclusive") && $(element).prop('checked') == true
      $("input[name='#{group_name}']").prop('checked', false)
      $(element).prop('checked', true)
    else
      $("input[name='#{group_name}'][data-mutually-exclusive=true]").prop('checked', false)

$(document)
  .on('click', '[data-object~="set-time-input-to-current-time"]', ->
    if $(this).data('time-of-day-format') == "24hour"
      setCurrentTime($(this))
    else
      setCurrentTime12Hour($(this))
    false
  )
  .on('click', '[data-object~="set-time-input-to-current-time-12hour"]', ->
    setCurrentTime12Hour($(this))
    false
  )
  .on("click", '[data-object~="clear-time-of-day-input"]', (event) ->
    clearTimeFields($(this), $(this).data('time-of-day-format'))
    event.preventDefault()
  )
  .on("click", '[data-object~="clear-time-duration-input"]', (event) ->
    clearTimeDurationFields($(this))
    event.preventDefault()
  )
  .on("click", '[data-object~="clear-date-input"]', ->
    clearDateFields($(this))
    false
  )
  .on('click', '[data-object~="set-date-input-to-current-date"]', ->
    setCurrentDate($(this))
    false
  )
  .on('click', '.survey-choices input', ->
    toggleMutuallyExclusive($(this))
    $(".survey-choices input").closest("label").removeClass("active")
    $(".survey-choices input:checked").closest("label").addClass("active")
  )
  .on("click", "[data-object~=submit-and-continue]", ->
    disablerWithSpinner($(this))
    $target = $($(this).data("target"))
    setTimeout (-> $target.submit()), 50
    false
  )
