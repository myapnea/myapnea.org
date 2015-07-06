@dailyEngagementReady = () ->
  margin =
    top: 20
    right: 20
    bottom: 30
    left: 50
  width = 960 - (margin.left) - (margin.right)
  height = 500 - (margin.top) - (margin.bottom)
  parseDate = d3.time.format('%Y-%m-%d').parse
  x = d3.time.scale().range([
    0
    width
  ])
  y = d3.scale.linear().range([
    height
    0
  ])
  xAxis = d3.svg.axis().scale(x).orient('bottom')
  yAxis = d3.svg.axis().scale(y).orient('left')
  line = d3.svg.line().x((d) ->
    x d.date
  ).y((d) ->
    y d.count
  )

  svgPosts = d3.select('#daily-engagement-posts').append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
  svgUsers = d3.select('#daily-engagement-users').append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
  svgSurveys = d3.select('#daily-engagement-surveys').append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
  svgWeek = d3.select('#daily-engagement-week').append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

  d3.json 'daily_engagement_data.json', (error, data) ->
    if error
      throw error
    data.posts.forEach (d, i) ->
      d.date = parseDate(d.date)
      d.count = +d.count
      d.index = i
      return
    x.domain d3.extent(data.posts, (d) ->
      d.date
    )
    y.domain d3.extent(data.posts, (d) ->
      d.count
    )
    svgPosts.append('g').attr('class', 'x axis').attr('transform', 'translate(0,' + height + ')').call xAxis
    svgPosts.append('g').attr('class', 'y axis').call(yAxis).append('text').attr('transform', 'rotate(-90)').attr('y', 6).attr('dy', '.71em').style('text-anchor', 'end').text 'Posts'
    svgPosts.append('path').datum(data.posts).attr('class', 'posts-line').attr 'd', line
    # svgPosts.append('g').attr('class', 'line-point').selectAll('circle').data( data.posts ).enter().append('circle').attr('cx', (d) -> x(d.date) ).attr('cy', (d) -> y(d.count) ).attr('r', 2.0).style('fill', 'white').style('stroke', 'steelblue')
    postPointElem = svgPosts.append('g').attr('class', 'line-point')
    postPoints = postPointElem.selectAll('circle').data(data.posts).enter().append('circle').attr('cx', (d) -> x(d.date) ).attr('cy', (d) -> y(d.count) ).attr('r', 2.0).style('fill', 'white').style('stroke', 'steelblue')
    postPoints.on('mouseover', (d) -> document.getElementById('posts'+d.index).style.display = 'block' )
    postPoints.on('mouseout', (d) -> document.getElementById('posts'+d.index).style.display = 'none' )
    postTips = postPointElem.selectAll('text').data(data.posts).enter().append('text').attr('dx', (d) -> x(d.date) - 50 ).attr('dy', (d) -> y(d.count) - 10).attr('display', 'none').attr('id', (d) -> 'posts'+d.index ).html((d) -> ("<tspan style='font-weight:bold'>" + d.count + " new posts</tspan> on " + d.date.toDateString()))

    data.users.forEach (d, i) ->
      d.date = parseDate(d.date)
      d.count = +d.count
      d.index = i
      return
    x.domain d3.extent(data.users, (d) ->
      d.date
    )
    y.domain d3.extent(data.users, (d) ->
      d.count
    )

    svgUsers.append('g').attr('class', 'x axis').attr('transform', 'translate(0,' + height + ')').call xAxis
    svgUsers.append('g').attr('class', 'y axis').call(yAxis).append('text').attr('transform', 'rotate(-90)').attr('y', 6).attr('dy', '.71em').style('text-anchor', 'end').text 'Users'
    svgUsers.append('path').datum(data.users).attr('class', 'users-line').attr 'd', line
    userPointElem = svgUsers.append('g').attr('class', 'line-point')
    userPoints = userPointElem.selectAll('circle').data( data.users ).enter().append('circle').attr('cx', (d) -> x(d.date) ).attr('cy', (d) -> y(d.count) ).attr('r', 2.0).style('fill', 'white').style('stroke', 'green')
    userPoints.on('mouseover', (d) -> document.getElementById('users'+d.index).style.display = 'block' )
    userPoints.on('mouseout', (d) -> document.getElementById('users'+d.index).style.display = 'none' )
    userTips = userPointElem.selectAll('text').data(data.users).enter().append('text').attr('dx', (d) -> x(d.date) - 50 ).attr('dy', (d) -> y(d.count) - 10).attr('display', 'none').attr('id', (d) -> 'users'+d.index ).html((d) -> ("<tspan style='font-weight:bold'>" + d.count + " new users</tspan> on " + d.date.toDateString()))


    data.surveys.forEach (d, i) ->
      d.date = parseDate(d.date)
      d.count = +d.count
      d.index = i
      return
    x.domain d3.extent(data.surveys, (d) ->
      d.date
    )
    y.domain d3.extent(data.surveys, (d) ->
      d.count
    )

    svgSurveys.append('g').attr('class', 'x axis').attr('transform', 'translate(0,' + height + ')').call xAxis
    svgSurveys.append('g').attr('class', 'y axis').call(yAxis).append('text').attr('transform', 'rotate(-90)').attr('y', 6).attr('dy', '.71em').style('text-anchor', 'end').text 'Surveys'
    svgSurveys.append('path').datum(data.surveys).attr('class', 'surveys-line').attr 'd', line
    surveyPointElem = svgSurveys.append('g').attr('class', 'line-point')
    surveyPoints = surveyPointElem.selectAll('circle').data( data.surveys ).enter().append('circle').attr('cx', (d) -> x(d.date) ).attr('cy', (d) -> y(d.count) ).attr('r', 2.0).style('fill', 'white').style('stroke', 'red')
    surveyPoints.on('mouseover', (d) -> document.getElementById('surveys'+d.index).style.display = 'block' )
    surveyPoints.on('mouseout', (d) -> document.getElementById('surveys'+d.index).style.display = 'none' )
    surveyTips = surveyPointElem.selectAll('text').data(data.surveys).enter().append('text').attr('dx', (d) -> x(d.date) - 50 ).attr('dy', (d) -> y(d.count) - 10).attr('display', 'none').attr('id', (d) -> 'surveys'+d.index ).html((d) -> ("<tspan style='font-weight:bold'>" + d.count + " new surveys</tspan> on " + d.date.toDateString()))


    weeklyPosts = data.posts.slice(Math.max(data.posts.length - 7, 1))
    weeklyUsers = data.users.slice(Math.max(data.users.length - 7, 1))
    weeklySurveys = data.surveys.slice(Math.max(data.surveys.length - 7, 1))

    x.domain d3.extent(weeklyPosts, (d) ->
      d.date
    )
    y.domain d3.extent(weeklyPosts.concat(weeklyUsers,weeklySurveys), (d) ->
      d.count
    )

    svgWeek.append('g').attr('class', 'x axis').attr('transform', 'translate(0,' + height + ')').call xAxis
    svgWeek.append('g').attr('class', 'y axis').call(yAxis).append('text').attr('transform', 'rotate(-90)').attr('y', 6).attr('dy', '.71em').style('text-anchor', 'end').text 'Weekly Counts'
    svgWeek.append('path').datum(weeklyPosts).attr('class', 'posts-line').attr 'd', line
    weekPostElem = svgWeek.append('g').attr('class', 'line-point')
    weekPostPoints = weekPostElem.selectAll('circle').data( weeklyPosts ).enter().append('circle').attr('cx', (d) -> x(d.date) ).attr('cy', (d) -> y(d.count) ).attr('r', 3.5).style('fill', 'white').style('stroke', 'steelblue')
    weekPostPoints.on('mouseover', (d) -> document.getElementById('weekposts'+d.index).style.display = 'block' )
    weekPostPoints.on('mouseout', (d) -> document.getElementById('weekposts'+d.index).style.display = 'none' )
    weekPostTips = weekPostElem.selectAll('text').data(weeklyPosts).enter().append('text').attr('dx', (d) -> x(d.date) - 50 ).attr('dy', (d) -> y(d.count) - 10).attr('display', 'none').attr('id', (d) -> 'weekposts'+d.index ).html((d) -> ("<tspan style='font-weight:bold'>" + d.count + " new posts</tspan> on " + d.date.toDateString()))
    svgWeek.append('path').datum(weeklyUsers).attr('class', 'users-line').attr 'd', line
    weekUserElem = svgWeek.append('g').attr('class', 'line-point')
    weekUserPoints = weekUserElem.selectAll('circle').data( weeklyUsers ).enter().append('circle').attr('cx', (d) -> x(d.date) ).attr('cy', (d) -> y(d.count) ).attr('r', 3.5).style('fill', 'white').style('stroke', 'green')
    weekUserPoints.on('mouseover', (d) -> document.getElementById('weekusers'+d.index).style.display = 'block' )
    weekUserPoints.on('mouseout', (d) -> document.getElementById('weekusers'+d.index).style.display = 'none' )
    weekUserTips = weekUserElem.selectAll('text').data(weeklyUsers).enter().append('text').attr('dx', (d) -> x(d.date) - 50 ).attr('dy', (d) -> y(d.count) - 10).attr('display', 'none').attr('id', (d) -> 'weekusers'+d.index ).html((d) -> ("<tspan style='font-weight:bold'>" + d.count + " new users</tspan> on " + d.date.toDateString()))
    svgWeek.append('path').datum(weeklySurveys).attr('class', 'surveys-line').attr 'd', line
    weekSurveyElem = svgWeek.append('g').attr('class', 'line-point')
    weekSurveyPoints = weekSurveyElem.selectAll('circle').data( weeklySurveys ).enter().append('circle').attr('cx', (d) -> x(d.date) ).attr('cy', (d) -> y(d.count) ).attr('r', 3.5).style('fill', 'white').style('stroke', 'red')
    weekSurveyPoints.on('mouseover', (d) -> document.getElementById('weeksurveys'+d.index).style.display = 'block' )
    weekSurveyPoints.on('mouseout', (d) -> document.getElementById('weeksurveys'+d.index).style.display = 'none' )
    weekSurveyTips = weekSurveyElem.selectAll('text').data(weeklySurveys).enter().append('text').attr('dx', (d) -> x(d.date) - 50 ).attr('dy', (d) -> y(d.count) - 10).attr('display', 'none').attr('id', (d) -> 'weeksurveys'+d.index ).html((d) -> ("<tspan style='font-weight:bold'>" + d.count + " new surveys</tspan> on " + d.date.toDateString()))
    return
