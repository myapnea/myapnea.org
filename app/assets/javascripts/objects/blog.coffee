$(document)
  .on('click', '[data-object~="toggle-broadcast-comment"]', () ->
    $(this).closest('.broadcast-comment-header').siblings('.broadcast-comment-body').toggle()
    if $(this).html() == '[-]'
      $(this).html('[+]')
    else
      $(this).html('[-]')
    false
  )
  .on('click', '[data-object~="blog-write-comment"]',  () ->
    parent_comment_id = $(this).data('parent-comment-id')
    broadcast_comment_id = $(this).data('broadcast-comment-id')
    $("#write_comment_#{parent_comment_id}_#{broadcast_comment_id}").hide()
    $("#comment_container_#{parent_comment_id}_#{broadcast_comment_id}").fadeIn('fast')
    false
  )
  .on('click', '[data-object~="blog-no-write-comment"]', () ->
    parent_comment_id = $(this).data('parent-comment-id')
    broadcast_comment_id = $(this).data('broadcast-comment-id')
    $("#comment_container_#{parent_comment_id}_#{broadcast_comment_id}").hide()
    $("#write_comment_#{parent_comment_id}_#{broadcast_comment_id}").show()
    false
  )

  .on('click', '[data-object~="broadcast-comment-tab"]', () ->
    parent_comment_id = $(this).data('parent-comment-id')
    broadcast_comment_id = $(this).data('broadcast-comment-id')
    action = $(this).data('action')
    $("[data-object~='broadcast-comment-tab'][data-parent-comment-id=#{parent_comment_id}]").removeClass('active')
    $(this).addClass('active')
    $("[data-object~='broadcast-comment-tab-content'][data-parent-comment-id=#{parent_comment_id}]").hide()
    $("[data-object~='broadcast-comment-tab-content'][data-parent-comment-id=#{parent_comment_id}][data-action=#{action}]").show()
    false
  )
  .on('click', '[data-object~="broadcast-comment-tab"][data-action~="preview"]', () ->
    parent_comment_id = $(this).data('parent-comment-id')
    broadcast_comment_id = $(this).data('broadcast-comment-id')
    input = "#broadcast_comment_description_#{parent_comment_id}_#{broadcast_comment_id}"
    params = {}
    params.broadcast_comment = { description: $(input).val() }
    params.parent_comment_id = parent_comment_id
    params.broadcast_comment_id = broadcast_comment_id
    $.post("#{root_url}broadcast_comments/preview", params, null, 'script')
    false
  )
