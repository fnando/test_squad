# Set up Codeclimate.
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path("#{__dir__}/../lib")

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)
require "rails"
require "bundler/setup"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)
require "test_squad"

app_file = File.join(__dir__, "support/app_#{Rails::VERSION::STRING}.rb")

if File.file?(app_file)
  require app_file
else
  require File.join(__dir__, "support/app.rb")
end

require "rails/test_help"
require "mocha"
require "mocha/mini_test"
require "minitest/utils"
require "minitest/autorun"
