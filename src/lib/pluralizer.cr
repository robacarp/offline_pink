require "wordsmith"

word = ARGV[0]
action = ARGV[1]

case action
when "pluralize"
  print Wordsmith::Inflector.pluralize(ARGV[0])
when "singularize"
  print Wordsmith::Inflector.singularize(ARGV[0])
else
  STDERR.puts "No such action #{action} available. Try 'pluralize' or 'singularize'"
end
