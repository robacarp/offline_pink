require "dotenv"
Dotenv.load "development.env"

require "./offline_pink/**"

require "amber"

require "../config/application"
require "./models/model_helpers"
require "./models/**"

def test
  result = Result.new()
  result.save
  insert_time = Time.now

  return unless timestamp = result.created_at
  result = Result.find(result.id)
  return unless result
  return unless timestamp2 = result.created_at
  puts timestamp.to_s("%F %X")
  puts timestamp2.to_s("%F %X")
  puts timestamp.to_s(Time::Format::ISO_8601_DATE_TIME.pattern)
  puts timestamp2.to_s(Time::Format::ISO_8601_DATE_TIME.pattern)
end
test
