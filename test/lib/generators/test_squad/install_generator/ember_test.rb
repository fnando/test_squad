require "test_helper"
require "generators/test_squad/install/install_generator"

class TestSquadEmberTest < Rails::Generators::TestCase
  tests TestSquad::InstallGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  setup do
    @destination_root = self.class.destination_root
    @gemfile_path = @destination_root.join("Gemfile").to_s
    FileUtils.rm_rf(@gemfile_path)
    FileUtils.touch(@gemfile_path)
  end

  teardown do
    FileUtils.rm_rf Rails.root.join("spec")
  end

  test "copy test_squad.rb" do
    run_generator %w[--framework ember]
    assert_file @destination_root.join("test/javascript/test_squad.rb"), /config.framework = "ember"/
  end

  test "create dirs" do
    run_generator %w[--framework ember]
    assert_directory @destination_root.join("test/javascript/unit")
    assert_directory @destination_root.join("test/javascript/routes")
    assert_directory @destination_root.join("test/javascript/models")
    assert_directory @destination_root.join("test/javascript/components")
    assert_directory @destination_root.join("test/javascript/views")
  end

  test "create test helper file" do
    run_generator %w[--framework ember]
    assert_file @destination_root.join("test/javascript/test_helper.js")
  end

  test "copy sample test file" do
    run_generator %w[--framework ember]
    assert_file @destination_root.join("test/javascript/unit/router_test.js")
  end

  test "add gems" do
    run_generator %w[--framework ember]
    assert_file @gemfile_path, /gem 'rails-assets-qunit'/
  end
end
