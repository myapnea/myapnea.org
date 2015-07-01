@researchTopicsReady = () ->
  console.log document.body
  if $("[data-object~='research-topic-meter']").length > 0
    $("[data-object~='research-topic-meter']").each ->

      # Set standard border radius for full width display
      if parseFloat($(this).data('progress')) > 95
        $(this).addClass 'border20'

      # Animate fill of progress bar
      $(this).width(0).animate {
        width: $(this).data('progress')+"%"
      }, 1000

      return
