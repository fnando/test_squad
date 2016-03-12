require "test_helper"
require "generators/test_squad/install/install_generator"

class TestSquadQunitTest < Rails::Generators::TestCase
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
    run_generator %w[--framework qunit]
    assert_file @destination_root.join("test/javascript/test_squad.rb"), /config.framework = "qunit"/
  end

  test "add gem" do
    run_generator %w[--framework qunit]
    assert_file @gemfile_path, /gem 'rails-assets-qunit'/
  end

  test "create app dir" do
    run_generator %w[--framework qunit]
    assert_directory @destination_root.join("test/javascript/dummy")
  end

  test "create test helper file" do
    run_generator %w[--framework qunit]
    assert_file @destination_root.join("test/javascript/test_helper.js")
  end

  test "copy sample test file" do
    run_generator %w[--framework qunit]
    assert_file @destination_root.join("test/javascript/dummy/answer_test.js")
  end
end
