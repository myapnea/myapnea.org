@researchTopicsReady = () ->
  animateProgressBar = (bar) ->
    # Set standard border radius for full width display
    if parseFloat($(bar).data('progress')) > 95
      $(bar).addClass 'border20'

    # Animate fill of progress bar
    $(bar).width(0).animate {
      width: $(bar).data('progress')+"%"
    }, 1000

    return

  $(document)
    .on('click', "[data-object~='rt-upvote']", (e) ->
      $('#endorse_'+$(this).data('rt')+'_1').prop 'checked', true
      target = $(this).data('target')
      $(target).collapse 'show'
    )
    .on('click', "[data-object~='rt-downvote']", () ->
      $('#endorse_'+$(this).data('rt')+'_0').prop 'checked', true
      target = $(this).data('target')
      $(target).collapse 'show'
    )
    .on('click', "[data-object~='rt-already-voted']", () ->
      target = $(this).data('target')
      childBar = $(target).find("[data-object~='research-topic-meter']").first()
      animateProgressBar($(childBar))
    )

  $("[data-object~='research-topic-meter']").each ->
    animateProgressBar($(this))
