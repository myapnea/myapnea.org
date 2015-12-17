@shareIconsReady = () ->

  $(".share-icons-animate").mouseenter ->
    $(this).filter(':not(:animated)').animate boxShadow: "0 3px 10px #888", top: "-5px", 150
    return
  $(".share-icons-animate").mouseleave ->
    $(this).animate boxShadow: "0 3px 5px #888", top: "0px", 150
    return
