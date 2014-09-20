require 'json'

require_relative 'lib/parser'

files = Dir.glob("sources/gcide/gcide_[a-z]-entries.xml")

word_count = 0
definition_count = 0

files.each do |file|
  
  puts "Parsing #{File.basename(file)}"
  
  result = Parser.new(File.read(file)).parse
  
  word_count += result.keys.count
  definition_count += result.values.inject(0) { |sum, hash| sum + hash[:definitions].count }
  
  new_file_name = File.basename(file, ".*")
  
  File.open("#{new_file_name}.json", "w") do |f|
    f.write(JSON.pretty_generate(JSON.parse(result.to_json)))
  end

end

puts "Words: #{word_count}"
puts "Definitions: #{definition_count}"
