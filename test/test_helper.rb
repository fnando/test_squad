# Set up Codeclimate.
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)
require File.expand_path('../../test/dummy/config/environment.rb',  __FILE__)
require 'rails/test_help'
require 'mocha'
require 'mocha/mini_test'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path('../fixtures', __FILE__)
end
