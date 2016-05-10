@activateProviderScroll = () ->
  if $("#current-provider-list").length > 0
    isLoading = false
    pageParam = 1
    $(window).scroll ->
      if $(document).height() - $(this).height() - $(this).scrollTop() < 200 && !isLoading
        isLoading = true
        pageParam = pageParam + 1
        params = {}
        params.page = pageParam
        $.post(root_url + 'providers/more', params, (->
          isLoading = false
        ), 'script')

@providersReady = () ->
  $("#video-play").mouseleave ->
    $(this).children("i").animate
      backgroundColor: "rgba(250,250,250,.43)"
      , 300
    return

  $("#video-play").mouseenter ->
    $(this).children("i").filter(':not(:animated)').animate
      backgroundColor: "#FFA400"
      , 300
    return

  activateProviderScroll()
