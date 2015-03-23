# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@postsReady = () ->
  $('[data-object~="text-area-autocomplete"]').textcomplete(
    [
      mentions: $('[data-object~="text-area-autocomplete"]').data('mentions')
      match: /\B@(\w*)$/i
      search: (term, callback) ->
        callback($.map(this.mentions, (mention) ->
          if mention.toLowerCase().indexOf(term.toLowerCase()) == 0
            return mention
          else
            return null
        ))
      index: 1
      replace: (mention) ->
        return '@' + mention + ' '
    ], { appendTo: 'body' }
  )

$(document)
  .on('click', '[data-object~="preview-post"]', () ->
    $.post(root_url + 'forums/' + $(this).data('forum-id') + '/topics/' + $(this).data('topic-id') + '/posts/preview', $("#post_description_#{$(this).data('post-id')}").serialize() + "&post_id=" + $(this).data('post-id'), null, "script")
  )
