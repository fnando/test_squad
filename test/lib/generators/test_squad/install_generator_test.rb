require "test_helper"
require "generators/test_squad/install/install_generator"

class TestSquadInstallGeneratorTest < Rails::Generators::TestCase
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

  test "detect spec directory" do
    FileUtils.mkdir_p @destination_root.join("spec")
    run_generator %w[--framework qunit]
    assert_directory @destination_root.join("spec/javascript")
  end

  test "detect test directory" do
    run_generator %w[--framework qunit]
    assert_directory @destination_root.join("test/javascript")
  end

  test "add rails-assets.org source" do
    run_generator %w[--framework qunit]
    assert_file @gemfile_path, %r[source "https://rails-assets.org"]
  end

  test "skip source" do
    run_generator %w[--framework qunit --skip-source]
    refute File.read(@gemfile_path).match(%r[source "https://rails-assets.org"])
  end
end
