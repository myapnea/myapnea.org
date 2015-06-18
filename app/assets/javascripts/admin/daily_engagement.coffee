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
    data.posts.forEach (d) ->
      d.date = parseDate(d.date)
      d.count = +d.count
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

    data.users.forEach (d) ->
      d.date = parseDate(d.date)
      d.count = +d.count
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


    data.surveys.forEach (d) ->
      d.date = parseDate(d.date)
      d.count = +d.count
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
    svgWeek.append('g').attr('class', 'y axis').call(yAxis).append('text').attr('transform', 'rotate(-90)').attr('y', 6).attr('dy', '.71em').style('text-anchor', 'end').text 'Counts'
    svgWeek.append('path').datum(weeklyPosts).attr('class', 'posts-line').attr 'd', line
    svgWeek.append('path').datum(weeklyUsers).attr('class', 'users-line').attr 'd', line
    svgWeek.append('path').datum(weeklySurveys).attr('class', 'surveys-line').attr 'd', line
    return
