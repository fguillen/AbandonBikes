ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "#{File.dirname(__FILE__)}/factories"
require "mocha"

class ActiveSupport::TestCase
  FIXTURES_PATH = "#{File.dirname(__FILE__)}/fixtures"
  
  def read_fixture( file_name )
    File.read( "#{FIXTURES_PATH}/#{file_name}")
  end
end
