@reportsReady = ->
  $("[data-object~=chartjs-report-chart]").each((index, element) ->
    if Math.floor(Math.random() * 2) == 1
      ctx = $(element)[0].getContext("2d")
      myChart = new Chart(ctx,
        type: "bar"
        data:
          labels: [
            "Red"
            "Blue"
            "Yellow"
            "Green"
            "Purple"
            "Orange"
          ]
          datasets: [ {
            label: "# of Votes"
            data: [
              12
              19
              3
              5
              2
              3
            ]
            backgroundColor: [
              "rgba(255, 99, 132, 0.2)"
              "rgba(54, 162, 235, 0.2)"
              "rgba(255, 206, 86, 0.2)"
              "rgba(75, 192, 192, 0.2)"
              "rgba(153, 102, 255, 0.2)"
              "rgba(255, 159, 64, 0.2)"
            ]
            borderColor: [
              "rgba(255,99,132,1)"
              "rgba(54, 162, 235, 1)"
              "rgba(255, 206, 86, 1)"
              "rgba(75, 192, 192, 1)"
              "rgba(153, 102, 255, 1)"
              "rgba(255, 159, 64, 1)"
            ]
            borderWidth: 1
          } ]
        options: scales: yAxes: [ { ticks: beginAtZero: true } ]
      )
    else
      ctx = $(element)[0].getContext("2d")
      myChart = new Chart(ctx,
        type: 'pie'
        data:
          datasets: [ {
            data: [
              randomScalingFactor()
              randomScalingFactor()
              randomScalingFactor()
              randomScalingFactor()
              randomScalingFactor()
            ]
            # backgroundColor: [
            #   "rgba(255, 99, 132, 0.2)"
            #   "rgba(54, 162, 235, 0.2)"
            #   "rgba(255, 206, 86, 0.2)"
            #   "rgba(75, 192, 192, 0.2)"
            #   "rgba(153, 102, 255, 0.2)"
            #   "rgba(255, 159, 64, 0.2)"
            # ]
            label: 'Dataset 1'
          } ]
          labels: [
            'Red'
            'Orange'
            'Yellow'
            'Green'
            'Blue'
          ]
        options: responsive: true
      )
  )


@randomScalingFactor = ->
  Math.round Math.random() * 100
