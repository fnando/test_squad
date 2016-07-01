require "test_helper"

class TestSquadRunnerTest < ActiveSupport::TestCase
  test "server adapter" do
    server = TestSquad::Runner.new.app_server
    assert_equal Rack::Handler::WEBrick, server
  end

  test "starts server" do
    runner = TestSquad::Runner.new
    config = runner.config
    app_server = mock
    app_server_options = {
      Port: config.server_port,
      Host: config.server_host,
      Logger: runner.logger,
      AccessLog: [],
      Silent: true
    }

    app_server
      .expects(:run)
      .with(Rails.application, app_server_options)

    runner
      .expects(:app_server)
      .returns(app_server)

    thread = runner.run_server
    thread.join
    thread.kill
  end

  test "execute tests" do
    runner = TestSquad::Runner.new
    config = runner.config
    process_status = mock
    calls = sequence("calls")

    Open3.expects(:capture2)
      .with(
        config.phantomjs_bin,
        runner.runner_script,
        config.server_uri,
        config.timeout.to_s
      )
      .returns(["OUTPUT", process_status])
      .in_sequence(calls)

    $stdout
      .expects(:<<)
      .with("OUTPUT")
      .in_sequence(calls)

    process_status
      .expects(:exitstatus)
      .returns(1234)
      .in_sequence(calls)

    runner
      .expects(:exit)
      .with(1234)
      .in_sequence(calls)

    runner.run_tests
  end
end
