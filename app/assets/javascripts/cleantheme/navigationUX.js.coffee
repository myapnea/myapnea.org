@navigationUXReady = () ->
  $(".hover-slide-left").mouseenter ->
    $(this).switchClass "list-shrink", "list-expand", 150
    return
  $(".hover-slide-left").mouseleave ->
    $(this).switchClass "list-expand", "list-shrink", 150
    return
