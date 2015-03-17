@verticalBarGraph = (canvas, data, labels) ->
  graphHeight = 500
  barWidth = 50
  barSeparation = 15
  maxData = 100
  horizontalDistance = barWidth + barSeparation

  textSize = 14
  textXOffset = barWidth / 2 - textSize / 2
  textYOffset = 20

  barHeightMultiplier = graphHeight / maxData
  textYPosition = graphHeight - barHeightMultiplier + 20

  data.append("rect")
    .attr("x", (d, i) -> String(i * horizontalDistance))
    .attr("y", (d, i) -> graphHeight - barHeightMultiplier * (1+d))
    .attr("fill", "#1765bc")
    .attr("width", String(barWidth))
    .attr("height", (d) -> d * barHeightMultiplier)

  data.append("text")
    .text((d,i) -> labels[i])
    .attr("transform", (d,i) -> "translate("+String(i * horizontalDistance + textXOffset)+","+textYPosition+")rotate(30)")
    .style("font-size", textSize)

  data.append("text")
    .text((d) -> d)
    .attr("x", (d, i) -> String(i * horizontalDistance + textXOffset))
    .attr("y", (d, i) -> graphHeight - d*barHeightMultiplier - textYOffset)
    .style("font-size", textSize)
