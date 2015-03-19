@ageOfDiagnosisReady = () ->
  canvas = d3.select("#age-of-diagnosis")
    .append("svg")
    .attr("width", "80%")
    .attr("height", "600px")
    .style("margin", "0px auto")
  data = canvas.selectAll("rect")
    .data([10,15,15,10,20,10,20])
    .enter()
  labels = ["0-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70+"]
  verticalBarGraph(canvas,data,labels)

