@healthRatingReady = () ->
  canvas = d3.select("#health-rating")
    .append("svg")
    .attr("width", "600px")
    .attr("height", "400px")
    .attr("max-width", "600px")
    .attr("max-height", "400px")
    .attr("viewBox", "0 0 300 300")
    .attr("preserveAspectRatio", "xMidYMid")
    .style("margin", "auto")
    .style("padding", "80px 80px")
  data = $("#health-rating").data('array')
  colors = ["#e54835", "#f4b46d", "#d9f0a3", "#78c679", "#16c63c"]
  labels = ["Poor", "Fair", "Good", "Very good", "Excellent"]
  pieChart(canvas,data,labels,150,colors)

@healthImprovementReady = () ->
  canvas = d3.select("#health-improvement")
    .append("svg")
    .attr("width", "600px")
    .attr("height", "400px")
    .attr("max-width", "600px")
    .attr("max-height", "400px")
    .attr("viewBox", "0 0 300 300")
    .attr("preserveAspectRatio", "xMidYMid")
    .style("margin", "auto")
    .style("padding", "80px 80px")
  data = $("#health-improvement").data('array')
  colors = ["#e54835", "#f4b46d", "#d9f0a3", "#78c679", "#16c63c"]
  labels = ["Much worse", "Somewhat worse", "About the same", "Somewhat better", "Much better"]
  pieChart(canvas,data,labels,150,colors)

@qolRatingReady = () ->
  canvas = d3.select("#qol-rating")
    .append("svg")
    .attr("width", "600px")
    .attr("height", "400px")
    .attr("max-width", "600px")
    .attr("max-height", "400px")
    .attr("viewBox", "0 0 300 300")
    .attr("preserveAspectRatio", "xMidYMid")
    .style("margin", "auto")
    .style("padding", "80px 80px")
  data = $("#qol-rating").data('array')
  colors = ["#e54835", "#f4b46d", "#d9f0a3", "#78c679", "#16c63c"]
  labels = ["Poor", "Fair", "Good", "Very good", "Excellent"]
  pieChart(canvas,data,labels,150,colors)
