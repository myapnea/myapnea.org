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
      # categories: ['Africa', 'America', 'Asia', 'Europe', 'Oceania']
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
    legend:
      # layout: 'vertical'
      # align: 'right'
      # verticalAlign: 'top'
      # x: -40
      # y: 10,
      # floating: true
      # borderWidth: 1
      # # backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF')
      # shadow: true
      enabled: false
    credits:
      enabled: false
    # series: [{
    #   name: 'Question One'
    #   data: [
    #     ['label1', 12],
    #     ['label2', 11]
    #   ]
    # }]
    series: json['series']
  )
