@fbReady = () ->
  window.fbAsyncInit = ->
    FB.init
      appId: "1573310816232212"
      xfbml: true
      version: "v2.2"

    return

  ((d, s, id) ->
    js = undefined
    fjs = d.getElementsByTagName(s)[0]
    return  if d.getElementById(id)
    js = d.createElement(s)
    js.id = id
    js.src = "//connect.facebook.net/en_US/sdk.js"
    fjs.parentNode.insertBefore js, fjs
    return
  ) document, "script", "facebook-jssdk"