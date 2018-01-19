# frozen_string_literal: true

json.version do
  json.string Myapnea::VERSION::STRING
  json.major Myapnea::VERSION::MAJOR
  json.minor Myapnea::VERSION::MINOR
  json.tiny Myapnea::VERSION::TINY
  json.build Myapnea::VERSION::BUILD
end
