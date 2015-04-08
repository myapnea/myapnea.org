@pieChart = (canvas, data, labels, radius, colors) ->
  n = labels.length
  if colors is null
    colors = []
    i = 0
    while i < 6
      colors[i] = randomOrange() if i%2
      colors[i] = randomBlue() if !(i%2)
      i++

  pie = d3.layout.pie().sort(null)
  pie(data)
  arc = d3.svg.arc()
    .innerRadius(0)
    .outerRadius(radius)

  arcs = canvas.selectAll("g.arc")
    .data(pie(data))
    .enter()
    .append("g")
    .attr("class", "arc")
    .attr("transform", "translate("+radius+","+radius+")")

  arcs.append("path")
    .attr("fill", (d,i) -> colors[i])
    .attr("d", arc)

  arcs.append("text")
    .attr("transform", (d) ->
      c = arc.centroid(d)
      x = c[0]
      y = c[1]
      h = Math.sqrt(x*x + y*y)
      "translate("+(x/h)*radius*1.2+","+(y/h)*radius*1.2+")"
    )
    .text((d,i) -> labels[i])
    .attr("text-anchor", (d) ->
      if (d.endAngle + d.startAngle)/2 > Math.PI then "end" else "start"
    )
    .style("font-size", "20px")
