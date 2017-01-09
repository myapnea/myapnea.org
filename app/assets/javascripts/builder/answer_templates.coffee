@answerTemplatesSortables = ->
  $('[data-object~="sortable-answer-templates"]').sortable(
    handle: '.move-handle'
    axis: 'y'
    stop: ->
      sortable_order = $(this).sortable('toArray', attribute: 'data-answer-template-id')
      params = {}
      params.answer_template_ids = sortable_order
      $.post("#{root_url}builder/surveys/#{$(this).data('survey')}/questions/#{$(this).data('question')}/answer_templates/reorder", params, null, 'script')
      true
  )

@builderAnswerTemplatesReady = ->
  answerTemplatesSortables()
