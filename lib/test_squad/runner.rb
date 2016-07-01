require "stringio"
require "logger"
require "open3"

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
      @logger ||= Logger.new(StringIO.new)
    end

    def app_server
      Rack::Handler.pick(["puma", "thin", "webrick"])
    end

    def run
      run_server
      run_tests
    end

    def run_server
      Thread.new do
        app_server.run Rails.application,
          Port: config.server_port,
          Host: config.server_host,
          Logger: logger,
          AccessLog: [],
          Silent: true
      end
    end

    def runner_script
      File.expand_path("../../../phantomjs/runner.js", __FILE__)
    end

    def run_tests
      system(
        config.phantomjs_bin,
        runner_script,
        config.server_uri,
        config.timeout.to_s
      )

      exit_code = $? ? $?.exitstatus : 0
      exit(exit_code)
    end
  end
end
