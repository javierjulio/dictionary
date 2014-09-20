require 'minitest/autorun'
require 'shoulda/context'

def load_fixture(file_name)
  path = File.expand_path("../fixtures/#{file_name}", __FILE__)
  File.read(path)
end
