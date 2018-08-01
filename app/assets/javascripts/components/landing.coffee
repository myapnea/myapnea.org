$(window).on("scroll", ->
  winTop = $(window).scrollTop()
  windowHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
  $(".scroll-down-arrow-visible").each ->
    pos = $(this).offset().top
    if pos - (windowHeight / 3) <= winTop
      $(this).addClass("scroll-down-arrow-invisible")
    else
      $(this).removeClass("scroll-down-arrow-invisible")
)
