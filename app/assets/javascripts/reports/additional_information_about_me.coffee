@maritalStatusReady = () ->
  canvas = d3.select("#marital-status")
    .append("svg")
    .attr("width", "100%")
    .attr("height", "300px")
  data = canvas.selectAll("rect")
    .data($("#marital-status").data('array'))
    .enter()
  labels = ["Now married", "Unmarried, but living with a partner", "Widowed", "Divorced", "Separated", "Never married"]
  horizontalBarGraph(canvas,data,labels)


@dailyActivitiesReady = () ->
  canvas = d3.select("#daily-activities")
    .append("svg")
    .attr("width", "80%")
    .attr("height", "700px")
    .style("margin", "0px auto")
  data = canvas.selectAll("rect")
    .data($("#daily-activities").data('array'))
    .enter()
  labels = ["Working full time (day shifts)", "Working full time (rotating or night shifts)", "Working part time (day shifts)", "Working part time (rotating or night shifts)", "Unemployed, laid off, or looking for work", "In school", "Stay-at-home parent or keeping household", "Retired", "Disabled"]
  verticalBarGraph(canvas,data,labels)


@difficultyPayingBasicsReady = () ->
  canvas = d3.select("#difficulty-affording-basics")
    .append("svg")
    .attr("width", "100%")
    .attr("height", "500px")
    .style("margin", "auto")
    .style("padding", "100px 35%")
  data = $("#difficulty-affording-basics").data('array')
  colors = ["#e54835", "#f4b46d", "#d9f0a3", "#78c679"]
  labels = ["Very Hard", "Hard", "Somewhat Hard", "Not Very Hard"]
  pieChart(canvas,data,labels,150,colors)
