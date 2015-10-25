require 'simplecov'
require "codeclimate-test-reporter"

module SimpleCov::Configuration
  def clean_filters
    @filters = []
  end
end

SimpleCov.configure do
  clean_filters
  load_adapter 'test_frameworks'
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'leadsquared'
require 'byebug'
require 'webmock/rspec'

SimpleCov.start do
  add_filter "/.rvm/"
end
CodeClimate::TestReporter.start
WebMock.disable_net_connect!(:allow => "codeclimate.com")

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end
