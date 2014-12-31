@questionsReady = () ->
  $('[data-object~="draw-chart"]').each( (index, element) ->
    # alert $(element).data('name')
    drawChart( element )
  )



@drawChart = (element) ->
  json = $(element).data('info')
  $(element).highcharts(
    chart:
      type: json['type'] || 'bar'
    title:
      text: json['title']
    subtitle:
      text: json['subtitle']
    xAxis:
      type: 'category'
      title:
        text: null
    yAxis:
      min: 0
      title:
        text: 'People'
        align: 'high'
      labels:
        overflow: 'justify'
    tooltip:
      valueSuffix: ' people'
    plotOptions:
      bar:
        dataLabels:
          enabled: true
        pointWidth: 20
    legend:
      enabled: false
    credits:
      enabled: false
    series: json['series']
  )
