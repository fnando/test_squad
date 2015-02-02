require 'stringio'
require 'logger'

module TestSquad
  class Runner
    def self.run
      new.run
    end

    def initialize
      Rails.configuration.logger = logger
    end

    def config
      TestSquad.configuration
    end

    def logger
      Logger.new(StringIO.new)
    end

    def app_server
      Rack::Handler.pick(['puma', 'thin', 'webrick'])
    end

    def run
      run_server
      run_tests
    end

    def run_server
      thread = Thread.new {
        app_server.run Rails.application,
          Port: config.server_port,
          Host: config.server_host,
          Logger: logger,
          AccessLog: []
      }

      thread.abort_on_exception = true
    end

    def run_tests
      system config.phantomjs_bin,
        File.expand_path('../../../phantomjs/runner.js', __FILE__),
        config.server_uri,
        config.timeout.to_s

      exit $?.exitstatus
    end
  end
end
