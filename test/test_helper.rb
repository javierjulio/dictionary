$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'parser'
require 'minitest/autorun'
require 'minitest/reporters'
require 'shoulda/context'

Minitest::Reporters.use!([Minitest::Reporters::SpecReporter.new])

def load_fixture(file_name)
  path = File.expand_path("../fixtures/#{file_name}", __FILE__)
  File.read(path)
end
