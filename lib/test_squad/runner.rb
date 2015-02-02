require 'stringio'
require 'logger'

module TestSquad
  class Runner
    def self.run
      new.run
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
      Rails.configuration.logger = logger

      thread = Thread.new {
        app_server.run Rails.application,
          Port: config.server_port,
          Host: config.server_host,
          Logger: logger,
          AccessLog: []
      }

      thread.abort_on_exception = true

      system config.phantomjs_bin,
        File.expand_path('../../../phantomjs/runner.js', __FILE__),
        config.server_uri,
        config.timeout.to_s

      exit $?.exitstatus
    end
  end
end
