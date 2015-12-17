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
      target = $(this).data('target')
      radio = $('#endorse_'+$(this).data('rt')+'_1')
      if radio.prop 'checked'
        $(target).collapse('hide')
        $(target).on('hidden.bs.collapse', () ->
          radio.prop 'checked', false
        )
      else
        radio.prop 'checked', true
        $(target).collapse 'show'
    )
    .on('click', "[data-object~='rt-downvote']", () ->
      target = $(this).data('target')
      radio = $('#endorse_'+$(this).data('rt')+'_0')
      if radio.prop 'checked'
        $(target).collapse 'hide'
        $(target).on('hidden.bs.collapse', () ->
          radio.prop 'checked', false
        )
      else
        radio.prop 'checked', true
        $(target).collapse 'show'
    )
    .on('click', "[data-object~='rt-already-voted']", () ->
      target = $(this).data('target')
      childBar = $(target).find("[data-object~='research-topic-meter']").first()
      animateProgressBar($(childBar))
    )

  $("[data-object~='research-topic-meter']").each ->
    animateProgressBar($(this))
