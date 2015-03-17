@maritalStatusReady = () ->
  canvas = d3.select("#marital-status")
    .append("svg")
    .attr("width", "100%")
    .attr("height", "300px")
  data = canvas.selectAll("rect")
    .data([8,22,31,36,48,100])
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
    .data([65,13,5,6,3,1,1,89,7])
    .enter()
  labels = ["Working full time (day shifts)", "Working full time (rotating or night shifts)", "Working part time (day shifts)", "Working part time (rotating or night shifts)", "Unemployed, laid off, or looking for work", "In school", "Stay-at-home parent or keeping household", "Retired", "Disabled"]
  verticalBarGraph(canvas,data,labels)


@difficultyPayingBasicsReady = () ->
  canvas = d3.select("#difficulty-paying-basics")
    .append("svg")
    .attr("width", "100%")
    .attr("height", "500px")
    .style("margin", "auto")
    .style("padding", "100px 35%")
  data = [45,31,17,7]
  labels = ["Very Hard", "Hard", "Somewhat Hard", "Not Very Hard"]
  pieChart(canvas,data,labels,150)
