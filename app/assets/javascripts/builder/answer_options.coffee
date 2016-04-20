@answerOptionsSortables = () ->
  $('[data-object~="sortable-answer-options"]').sortable(
    handle: '.move-handle'
    axis: 'y'
    stop: () ->
      sortable_order = $(this).sortable('toArray', attribute: 'data-answer-option-id')
      params = {}
      params.answer_option_ids = sortable_order
      $.post("#{root_url}builder/surveys/#{$(this).data('survey')}/questions/#{$(this).data('question')}/answer_templates/#{$(this).data('answer-template')}/answer_options/reorder", params, null, 'script')
      true
  )

@builderAnswerOptionsReady = () ->
  answerOptionsSortables()
