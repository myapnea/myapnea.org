@researchTopicsReady = () ->
  $(document)
    .on('click', "[data-object~='rt-upvote']", (e) ->
      console.log "clicked like"
      $('#endorse_'+$(this).data('rt')+'_1').prop 'checked', true
    )
    .on('click', "[data-object~='rt-downvote']", () ->
      console.log "clicked dislike"
      $('#endorse_'+$(this).data('rt')+'_0').prop 'checked', true
    )

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
