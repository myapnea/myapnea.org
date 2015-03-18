@healthRatingReady = () ->
  canvas = d3.select("#health-rating")
    .append("svg")
    .attr("width", "100%")
    .attr("height", "500px")
    .style("margin", "auto")
    .style("padding", "100px 35%")
  data = [35,31,17,7,10]
  colors = ["#e54835", "#f4b46d", "#d9f0a3", "#78c679", "#16c63c"]
  labels = ["Poor", "Fair", "Good", "Very Good", "Excellent"]
  pieChart(canvas,data,labels,150,colors)

@qolRatingReady = () ->
  canvas = d3.select("#qol-rating")
    .append("svg")
    .attr("width", "100%")
    .attr("height", "500px")
    .style("margin", "auto")
    .style("padding", "100px 35%")
  data = [35,31,17,7,10]
  colors = ["#e54835", "#f4b46d", "#d9f0a3", "#78c679", "#16c63c"]
  labels = ["Poor", "Fair", "Good", "Very Good", "Excellent"]
  pieChart(canvas,data,labels,150,colors)
