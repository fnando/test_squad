desc 'Run JavaScript tests'
task :test_squad do
  ENV['RAILS_ENV'] = 'test'
  ENV['RACK_ENV'] = 'test'

  require './config/environment'
  require 'stringio'

  phantomjs_bin = ENV.fetch('PHANTOMJS_BIN', 'phantomjs')
  port = ENV.fetch('PORT', 50000)
  host = ENV.fetch('HOST', 'localhost')
  path = ENV.fetch('TEST_PATH', '/tests')
  timeout = ENV.fetch('TIMEOUT', '10')
  url = File.join("http://#{host}:#{port}", path)
  logger = Logger.new(StringIO.new)

  handler = Rack::Handler.pick(['puma', 'thin', 'webrick'])

  Rails.configuration.logger = logger

  thread = Thread.new {
    handler.run Rails.application,
      Port: port,
      Host: host,
      Logger: logger,
      AccessLog: []
  }

  thread.abort_on_exception = true

  system phantomjs_bin,
    File.expand_path('../../../phantomjs/runner.js', __FILE__),
    url,
    timeout

  exit $?.exitstatus
end
