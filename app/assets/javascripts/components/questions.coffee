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
      height: json['chartHeight'] || null
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
      allowDecimals: false
      title:
        text: 'Members'
        margin: 15
      labels:
        overflow: 'justify'
      offset: 5
    tooltip:
      valueSuffix: ' members'
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
