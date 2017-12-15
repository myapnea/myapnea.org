@drawLandingPageCharts = ->
  if $("#landing-page-users-surveys-chart").length > 0
    Highcharts.chart "landing-page-users-surveys-chart",
      credits: enabled: false
      chart: type: "line"
      chart: backgroundColor: "transparent"
      title: text: ""
      xAxis: categories: [
        "2013"
        "2014"
        "2015"
        "2016"
        "2017"
      ]
      yAxis:
        # min: 0
        title:
          text: ""
      # plotOptions: line:
      #   dataLabels: enabled: true
      #   enableMouseTracking: false
      series: [
        {
          name: "Surveys"
          color: "#ffa726" # $p400-orange
          data: [
            0
            5662
            57786
            91320
            118016
          ]
        }
        {
          name: "Users"
          type: "area"
          color: "#42a5f5" # $p400-blue
          data: [
            0
            1019
            6133
            8804
            10888
          ]
        }
      ]

@surveyReportCharts = ->
  $("[data-object~=survey-report-chart]").each((index, element) ->
    $(element).highcharts
      credits: enabled: false
      chart:
        backgroundColor: "#e3f2fd" # $p50-blue
        borderColor: "transparent"
        plotBackgroundColor: null
        plotBorderWidth: 0
        plotShadow: false
      title: $(element).data("title")
      tooltip: pointFormat: "{series.name}: <b>{point.percentage:.1f}%</b>"
      series: $(element).data("series")
      xAxis: $(element).data("x-axis")
      yAxis: $(element).data("y-axis")
      tooltip:
        formatter: -> this.x
  )

@chartsReady = ->
  Highcharts.setOptions(
    lang:
      thousandsSep: ","
    colors: [
      "#7cb5ec"
      "#90ed7d"
      "#f7a35c"
      "#8085e9"
      "#f15c80"
      "#e4d354"
      "#2b908f"
      "#f45b5b"
      "#91e8e1"
    ]
  )
  drawLandingPageCharts()
  surveyReportCharts()
