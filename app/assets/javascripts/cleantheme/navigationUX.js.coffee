@navigationUXReady = () ->
  $(".hover-slide-left").mouseenter ->
    $(this).switchClass "list-shrink", "list-expand", 150
    return
  $(".hover-slide-left").mouseleave ->
    $(this).switchClass "list-expand", "list-shrink", 150
    return

  $(".share-icons-animate").mouseenter ->
    $(this).animate boxShadow: "0 3px 10px #888", top: "-5px", 150
    return
  $(".share-icons-animate").mouseleave ->
    $(this).animate boxShadow: "0 3px 5px #888", top: "0px", 150
    return
