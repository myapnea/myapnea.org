@rankingUXReady = () ->
  $(document)
    .on('click', ".expand-research-topic", () ->
      if $(this).html() is "Read more"
        $(this).html "Read less"
      else
        $(this).html "Read more"
      return
    )
    .ready ->
      # Load progress vars for things that users have already voted on
      $(".progress.in").each () ->
      currentProgress = parseFloat( $(this).find(".progress-bar").attr("aria-valuenow") )
      $(this).find(".progress-bar").width currentProgress + "%"
      return
  if $("#researchTopicIndexModal").length > 0
      $("#researchTopicIndexModal").modal "show"
