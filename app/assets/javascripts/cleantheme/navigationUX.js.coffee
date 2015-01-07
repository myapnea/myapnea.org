@navigationUXReady = () ->
  $(".hover-slide-left").mouseenter ->
    $(this).filter(':not(:animated)').switchClass "list-shrink", "list-expand", 150
    return
  $(".hover-slide-left").mouseleave ->
    $(this).switchClass "list-expand", "list-shrink", 150
    return

  $(".share-icons-animate").mouseenter ->
    $(this).filter(':not(:animated)').animate boxShadow: "0 3px 10px #888", top: "-5px", 150
    return
  $(".share-icons-animate").mouseleave ->
    $(this).animate boxShadow: "0 3px 5px #888", top: "0px", 150
    return

  # Navigation hover
  # $("#testnavbar").children("li").mouseenter ->
  #   $(this).animate borderBottomColor: "#5999de", 150
  #   $(this).animate borderBottomWidth: "5px", 150
  #   return
  # $("#testnavbar").children("li").mouseleave ->
  #   unless $(this).hasClass("active")
  #     $(this).animate borderBottomColor: "rgba(36,50,100,0)", 300
  #     $(this).animate borderBottomWidth: "-5px", 300
  #   return
