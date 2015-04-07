@data

json.nodes @data do |datum|
  json.name datum[0]
  json.id datum[1]
  json.frequency datum[2]
end

json.links @data do |datum|
  json.source datum[1]
  json.target "conditions-sleep-apnea"
end


### FORMAT
# {
#   nodes: [
#     {
#       name:
#       option:
#       id:
#       frequency:
#     },
#   ]
#   links: [
#     {
#       source: ID
#       target: ID
#     }
#   ]
# }
