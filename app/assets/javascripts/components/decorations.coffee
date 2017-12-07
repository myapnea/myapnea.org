$(window).on("scroll", ->
  winTop = $(window).scrollTop()
  windowHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
  $("[data-object~=decoration-sun-horizon-scroll]").each ->
    if windowHeight - winTop > 0 && windowHeight > 0
      percent = (windowHeight - winTop) / windowHeight * 100
    else
      percent = 0
    $(this).css("transform", "translate(#{50 - percent}%)")
)
