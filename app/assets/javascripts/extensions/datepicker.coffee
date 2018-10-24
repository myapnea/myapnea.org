@datepickerReady = ->
  $(".datepicker-dropdown").remove()
  $(".datepicker").datepicker("remove")
  $(".datepicker").datepicker(autoclose: true)
