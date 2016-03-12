module TestSquad
  class Configuration
    # Set the enabled JavaScript library.
    attr_accessor :framework

    # Set the phantomjs bin path.
    # This can also be set through the TEST_SQUAD_PHANTOMJS_BIN env var.
    # It defaults to `phantomjs`.
    attr_writer :phantomjs_bin

    # Set the test server host.
    # This can also be set through the TEST_SQUAD_SERVER_HOST env var.
    # It defaults to `127.0.0.1`
    attr_writer :server_host

    # Set the test server port.
    # This can also be set through the TEST_SQUAD_SERVER_PORT env var.
    # It defaults to `42424`
    attr_writer :server_port

    # Set the test server path.
    # You may map the tests path to something else. This change
    # must be reflected here. This can also be set through the
    # TEST_SQUAD_SERVER_PATH env var.
    # It defaults to `/tests`.
    attr_writer :server_path

    # Set the test timeout.
    # This can also be set through the TEST_SQUAD_TIMEOUT env var.
    # It defaults to `10` seconds.
    attr_writer :timeout

    def server_uri
      File.join("http://#{server_host}:#{server_port}", server_path)
    end

    def phantomjs_bin
      get_value("TEST_SQUAD_PHANTOMJS_BIN", __method__, "phantomjs")
    end

    def server_host
      get_value("TEST_SQUAD_SERVER_HOST", __method__, "127.0.0.1")
    end

    def server_port
      get_value("TEST_SQUAD_SERVER_PORT", __method__, 42_424)
    end

    def server_path
      get_value("TEST_SQUAD_SERVER_PATH", __method__, "/tests")
    end

    def timeout
      get_value("TEST_SQUAD_TIMEOUT", __method__, 10)
    end

    private

    def get_value(env_var, option_name, default_value)
      ENV[env_var] ||
        instance_variable_get("@#{option_name}") ||
        default_value
    end
  end
end
