@utmx_section = ->

@utmx = ->

@ABTestingReady = () ->
  do ->
    k = '91307595-1'
    d = document
    l = d.location
    c = d.cookie

    f = (n) ->
      if c
        i = c.indexOf(n + '=')
        if i > -1
          j = c.indexOf(';', i)
          return escape(c.substring(i + n.length + 1, if j < 0 then c.length else j))
      return

    if l.search.indexOf('utm_expid=' + k) > 0
      return
    x = f('__utmx')
    xx = f('__utmxx')
    h = l.hash
    $("#body-javascripts").append '<script src="' + 'http' + (if l.protocol == 'https:' then 's://ssl' else '://www') +
      '.google-analytics.com/ga_exp.js?' + 'utmxkey=' + k + '&utmx=' + (if x then x else '') +
      '&utmxx=' + (if xx then xx else '') + '&utmxtime=' + (new Date).valueOf() +
      (if h then '&utmxhash=' + escape(h.substr(1)) else '') +
      '" type="text/javascript" charset="utf-8"></script>'
    return
