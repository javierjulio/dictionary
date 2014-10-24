require 'json'

require_relative 'lib/parser'

files = Dir.glob("sources/gcide/gcide_[a-z]-entries.xml")

word_count = 0
definition_count = 0
result = {}

files.each do |file|
  
  puts "Parsing #{File.basename(file)}"
  
  result.merge! Parser.new(File.read(file)).parse
  
end


result.keys.each do |word|
  result.delete(word) if result[word][:definitions].count == 0
end


File.open("dictionary.json", "w") do |f|
  f.write(JSON.pretty_generate(JSON.parse(result.to_json)))
end

word_count += result.keys.count
definition_count += result.values.inject(0) { |sum, hash| sum + hash[:definitions].count }

puts "Words: #{word_count}"
puts "Definitions: #{definition_count}"



smaller_data_set = {
  artifact: result["artifact"],
  homœomeria: result["homœomeria"],
  deduction: result["deduction"],
  reduction: result["reduction"],
  aëneous: result["aëneous"]
}

File.open("dictionary-test.json", "w") do |f|
  f.write(JSON.pretty_generate(JSON.parse(smaller_data_set.to_json)))
end
