@showTopicReplyBox = (parent_comment_id, reply_id) ->
  $("#write_comment_#{parent_comment_id}_#{reply_id}").hide()
  $("#comment_container_#{parent_comment_id}_#{reply_id}").fadeIn('fast')

@hideTopicReplyBox = (parent_comment_id, reply_id) ->
  $('[name=password]').tooltip('destroy')
  $("#comment_container_#{parent_comment_id}_#{reply_id}").html('')
  $("#comment_container_#{parent_comment_id}_#{reply_id}").hide()
  $("#write_comment_#{parent_comment_id}_#{reply_id}").show()

@topicsReady = () ->
  if window.location.hash == '#write-a-reply'
    $("#write_comment_root_new a").click()
  else if window.location.hash.substring(1,8) == 'comment'
    $("#{window.location.hash}").addClass('highlighted-reply')


$(document)
  .on('click', '[data-object~="toggle-reply"]', () ->
    $(this).closest('.broadcast-comment-header').siblings('.broadcast-comment-body').toggle()
    if $(this).html() == '[-]'
      $(this).html('[+]')
    else
      $(this).html('[-]')
    false
  )
  .on('click', '[data-object~="chapter-no-write-comment"]', () ->
    parent_comment_id = $(this).data('parent-comment-id')
    reply_id = $(this).data('reply-id')
    hideTopicReplyBox(parent_comment_id, reply_id)
    false
  )
  .on('click', '[data-object~="reply-tab"]', () ->
    parent_comment_id = $(this).data('parent-comment-id')
    reply_id = $(this).data('reply-id')
    action = $(this).data('action')
    $("[data-object~='reply-tab'][data-parent-comment-id=#{parent_comment_id}]").removeClass('active')
    $(this).addClass('active')
    $("[data-object~='reply-tab-content'][data-parent-comment-id=#{parent_comment_id}]").hide()
    $("[data-object~='reply-tab-content'][data-parent-comment-id=#{parent_comment_id}][data-action=#{action}]").show()
    false
  )
  .on('click', '[data-object~="reply-tab"][data-action~="preview"]', () ->
    parent_comment_id = $(this).data('parent-comment-id')
    reply_id = $(this).data('reply-id')
    input = "#reply_description_#{parent_comment_id}_#{reply_id}"
    params = {}
    params.reply = { description: $(input).val() }
    params.parent_comment_id = parent_comment_id
    params.reply_id = reply_id
    $.post("#{root_url}replies/preview", params, null, 'script')
    false
  )
