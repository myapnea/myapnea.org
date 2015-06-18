json.posts @posts do |datum|
  json.date datum[0]
  json.count datum[1].count
end

json.users @users do |datum|
  json.date datum[0]
  json.count datum[1].count
end

json.surveys @surveys do |datum|
  json.date datum[0]
  json.count datum[1].count
end
