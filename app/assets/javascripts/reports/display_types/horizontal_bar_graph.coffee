@horizontalBarGraph = (canvas, data, labels) ->
  graphHeight = 500
  barHeight = 30
  barSeparation = 20
  maxData = 100
  verticalDistance = barHeight + barSeparation

  textXOffset = 20
  textYOffset = verticalDistance / 2 - 7

  barHeightMultiplier = 300 / maxData
  textXPosition = 300 - barHeightMultiplier - 20

  data.append("rect")
    .attr("x", (d, i) -> 300 - barHeightMultiplier)
    .attr("y", (d, i) -> i * verticalDistance)
    .attr("fill", "#1765bc")
    .attr("height", barHeight)
    .attr("width", (d) -> d * barHeightMultiplier)

  data.append("text")
    .text( (d,i) -> labels[i] )
    .attr("x", (d) -> textXPosition)
    .style("text-anchor", "end")
    .attr("y", (d, i) -> i * verticalDistance + textYOffset)

  data.append("text")
    .text((d) -> d)
    .attr("x", (d, i) -> 300 + (d - 1) * barHeightMultiplier + 10)
    .attr("y", (d, i) -> i * verticalDistance + textYOffset)
