require 'test_helper'

class TestSquadConfigurationTest < ActiveSupport::TestCase
  def with_env(options, &block)
    options.each do |name, value|
      ENV[name] = value.to_s
    end

    yield
  ensure
    options.each do |name, _|
      ENV.delete(name)
    end
  end

  def assert_configuration(env_var, option_name, default_value)
    assert_env_var(env_var, option_name)
    assert_option_value(option_name)
    assert_default_value(option_name, default_value)
  end

  def assert_env_var(env_var, option_name)
    custom_value = "#{env_var}_CUSTOM_VALUE"

    with_env(env_var => custom_value) do
      assert_equal custom_value, @config.public_send(option_name)
    end
  end

  def assert_option_value(option_name)
    custom_value = "#{option_name}_custom_value"
    @config.public_send("#{option_name}=", custom_value)
    assert_equal custom_value, @config.public_send(option_name)
  end

  def assert_default_value(option_name, default_value)
    @config.public_send("#{option_name}=", nil)
    assert_equal default_value, @config.public_send(option_name)
  end

  setup do
    @config = TestSquad::Configuration.new
  end

  test 'phantomjs_bin option' do
    assert_configuration 'TEST_SQUAD_PHANTOMJS_BIN', 'phantomjs_bin', 'phantomjs'
  end

  test 'server_host option' do
    assert_configuration 'TEST_SQUAD_SERVER_HOST', 'server_host', '127.0.0.1'
  end

  test 'server_port option' do
    assert_configuration 'TEST_SQUAD_SERVER_PORT', 'server_port', 42424
  end

  test 'server_path option' do
    assert_configuration 'TEST_SQUAD_SERVER_PATH', 'server_path', '/tests'
  end

  test 'timeout option' do
    assert_configuration 'TEST_SQUAD_TIMEOUT', 'timeout', 10
  end

  test 'server uri' do
    assert_equal @config.server_uri, 'http://127.0.0.1:42424/tests'
  end
end
