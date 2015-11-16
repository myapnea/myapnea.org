# Heatmap modeled after http://bl.ocks.org/tjdecke/5558084
@engagementHeatmapReady = () ->
  margin =
    top: 50
    right: 0
    bottom: 100
    left: 30
  width = 960 - (margin.left) - (margin.right)
  height = 430 - (margin.top) - (margin.bottom)
  gridSize = Math.floor(width / 24)
  legendElementWidth = gridSize * 2
  buckets = 9
  colors = [
    '#ffffd9'
    '#edf8b1'
    '#c7e9b4'
    '#7fcdbb'
    '#41b6c4'
    '#1d91c0'
    '#225ea8'
    '#253494'
    '#081d58'
  ]
  days = [
    'Mo'
    'Tu'
    'We'
    'Th'
    'Fr'
    'Sa'
    'Su'
  ]
  times = [
    '1a'
    '2a'
    '3a'
    '4a'
    '5a'
    '6a'
    '7a'
    '8a'
    '9a'
    '10a'
    '11a'
    '12a'
    '1p'
    '2p'
    '3p'
    '4p'
    '5p'
    '6p'
    '7p'
    '8p'
    '9p'
    '10p'
    '11p'
    '12p'
  ]

  heatmapChart = (data, mapId) ->
    svg = d3.select(mapId).append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
    dayLabels = svg.selectAll('.dayLabel').data(days).enter().append('text').text((d) ->
      d
    ).attr('x', 0).attr('y', (d, i) ->
      i * gridSize
    ).style('text-anchor', 'end').attr('transform', 'translate(-6,' + gridSize / 1.5 + ')').attr('class', (d, i) ->
      if i >= 0 and i <= 4 then 'dayLabel mono axis axis-workweek' else 'dayLabel mono axis'
    )
    timeLabels = svg.selectAll('.timeLabel').data(times).enter().append('text').text((d) ->
      d
    ).attr('x', (d, i) ->
      i * gridSize
    ).attr('y', 0).style('text-anchor', 'middle').attr('transform', 'translate(' + gridSize / 2 + ', -6)').attr('class', (d, i) ->
      if i >= 7 and i <= 16 then 'timeLabel mono axis axis-worktime' else 'timeLabel mono axis'
    )

    colorScale = d3.scale.quantile().domain([
      0
      buckets - 1
      d3.max(data, (d) ->
        d.value
      )
    ]).range(colors)
    cards = svg.selectAll('.hour').data(data, (d) ->
      d.day + ':' + d.hour
    )
    cards.append 'title'
    cards.enter().append('rect').attr('x', (d) ->
      (d.hour - 1) * gridSize
    ).attr('y', (d) ->
      (d.day - 1) * gridSize
    ).attr('rx', 4).attr('ry', 4).attr('class', 'hour bordered').attr('width', gridSize).attr('height', gridSize).style 'fill', colors[0]
    cards.transition().duration(1000).style 'fill', (d) ->
      colorScale d.value
    cards.select('title').text (d) ->
      d.value
    cards.exit().remove()
    legend = svg.selectAll('.legend').data([ 0 ].concat(colorScale.quantiles()), (d) ->
      d
    )
    legend.enter().append('g').attr 'class', 'legend'
    legend.append('rect').attr('x', (d, i) ->
      legendElementWidth * i
    ).attr('y', height).attr('width', legendElementWidth).attr('height', gridSize / 2).style 'fill', (d, i) ->
      colors[i]
    legend.append('text').attr('class', 'mono').text((d) ->
      '≥ ' + Math.round(d)
    ).attr('x', (d, i) ->
      legendElementWidth * i
    ).attr 'y', height + gridSize
    legend.exit().remove()
    return

  $('.engagement-heatmap').each (heatmap) ->
    heatmapId = '#'+$(this).attr('id')
    console.log heatmapId
    rawData = $(this).data('array')
    data = []
    dayAdjustment = rawData[0][0] - 1
    for i of rawData
      data.push
        'day' : rawData[i][0] - dayAdjustment
        'hour' : rawData[i][1] + 1
        'value' : rawData[i][2]
    heatmapChart data, heatmapId
