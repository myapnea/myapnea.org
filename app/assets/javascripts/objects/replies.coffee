@showReplyBox = (parent_reply_id, reply_id) ->
  $("#write_reply_#{parent_reply_id}_#{reply_id}").hide()
  $("#comment_container_#{parent_reply_id}_#{reply_id}").fadeIn("fast")

@hideReplyBox = (parent_reply_id, reply_id) ->
  $("[name=password]").tooltip("dispose")
  $("#comment_container_#{parent_reply_id}_#{reply_id}").html("")
  $("#comment_container_#{parent_reply_id}_#{reply_id}").hide()
  $("#write_reply_#{parent_reply_id}_#{reply_id}").show()

@repliesReady = ->
  if window.location.hash == "#write-a-reply"
    $("#write_reply_root_new a").click()
  else if window.location.hash.substring(1,8) == "comment"
    $("#{window.location.hash}-container").addClass("highlighted-reply")

$(document)
  .on("click", "[data-object~=toggle-reply]", ->
    $(this).closest(".reply-header").siblings(".reply-body,.reply-avatar-container").toggle()
    if $(this).html() == "[-]"
      $(this).html("[+]")
    else
      $(this).html("[-]")
    false
  )
  .on("click", "[data-object~=parent-no-write-reply]", ->
    parent_reply_id = $(this).data("parent-reply-id")
    reply_id = $(this).data("reply-id")
    hideReplyBox(parent_reply_id, reply_id)
    false
  )
  .on("click", "[data-object~=reply-tab]", ->
    parent_reply_id = $(this).data("parent-reply-id")
    reply_id = $(this).data("reply-id")
    action = $(this).data("action")
    $("[data-object~=reply-tab][data-parent-reply-id=#{parent_reply_id}]").removeClass("active")
    $(this).addClass("active")
    $("[data-object~=reply-tab-content][data-parent-reply-id=#{parent_reply_id}]").hide()
    $("[data-object~=reply-tab-content][data-parent-reply-id=#{parent_reply_id}][data-action=#{action}]").show()
    false
  )
  .on("click", "[data-object~=reply-tab][data-action~=preview]", ->
    parent_reply_id = $(this).data("parent-reply-id")
    reply_id = $(this).data("reply-id")
    input = "#reply_description_#{parent_reply_id}_#{reply_id}"
    params = {}
    params.reply = { description: $(input).val() }
    params.parent_reply_id = parent_reply_id
    params.reply_id = reply_id
    $.post("#{root_url}replies/preview", params, null, "script")
    false
  )
  .on("click", "[data-object~=bold-selection]", ->
    boldSelection($($(this).data("target"))[0])
    false
  )
  .on("click", "[data-object~=italic-selection]", ->
    italicizeSelection($($(this).data("target"))[0])
    false
  )
  .on("click", "[data-object~=link-selection]", ->
    linkSelection($($(this).data("target"))[0])
    false
  )
  .on("click", "[data-object~=quote-selection]", ->
    quoteSelection($($(this).data("target"))[0])
    false
  )
  .on("click", ".img-zoom-message", ->
    $(this).toggleClass("img-zoom-large-view")
  )
