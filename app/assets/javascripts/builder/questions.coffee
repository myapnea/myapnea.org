@questionSortables = ->
  $('[data-object~="sortable-questions"]').sortable(
    handle: '.move-handle'
    axis: 'y'
    stop: ->
      sortable_order = $(this).sortable('toArray', attribute: 'data-question-id')
      params = {}
      params.question_ids = sortable_order
      $.post("#{root_url}builder/surveys/#{$(this).data('survey')}/questions/reorder", params, null, 'script')
      true
  )

@builderQuestionsReady = ->
  questionSortables()
