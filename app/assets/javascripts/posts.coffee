# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@linkForumNames = () ->
  $("[data-object~='link-forum-names']").each( (index, element) ->
    $(element).html(
      $(element).html().replace(/@([a-zA-Z0-9]+)/g, (x) -> "<a href=\"#{root_url}members/#{x.replace(/@/,'')}\">#{x}</a>")
    )
  )

@postsReady = () ->
  $('[data-object~="text-area-autocomplete"]').textcomplete(
    [
      mentions: $('[data-object~="text-area-autocomplete"]').data('mentions')
      match: /\B@(\w*)$/i
      search: (term, callback, match) ->
        $.getJSON("#{root_url}members_search", { q: term })
          .done( (resp) ->
            callback(resp) # `resp` must be an Array
          )
          .fail( () ->
            callback([]) # Callback must be invoked even if something went wrong.
          )
      index: 1
      replace: (mention) -> '@' + mention + ' '
    ], { appendTo: 'body' }
  )
  linkForumNames()

$(document)
  .on('click', '[data-object~="preview-post"]', () ->
    $.post(root_url + 'forums/' + $(this).data('forum-id') + '/topics/' + $(this).data('topic-id') + '/posts/preview', $("#post_description_#{$(this).data('post-id')}").serialize() + "&post_id=" + $(this).data('post-id'), null, "script")
  )
  .on('click', '[data-object~="toggle-post"]', () ->
    $("#post_contents_#{$(this).data('post-id')}").toggle()
    false
  )
  .on('click', '[data-object~="remove-max-height"]', () ->
    $(this).css('max-height', 'none')
    $(this).css('cursor', 'default')
    false
  )
