require 'bundler/setup'
require 'json'

class RhythmApiMock
  attr_reader :file_name
  def initialize(file_name)
    @file_name = file_name
  end
  
  def json
    JSON.parse(file_read, symbolize_names: true)
  end
  
  private
  def file_read
    File.open(file_name).read
  end
end
