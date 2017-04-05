@tooltipsReady = ->
  $('.tooltip').remove()
  return unless document.documentElement.ontouchstart == undefined
  $('[data-toggle="tooltip"]').tooltip() # TODO: Remove this line, replace all with "rel" format
  $("[rel~=tooltip]").tooltip(trigger: 'hover')
