require 'test_helper'
require 'generators/test_squad/install/install_generator'

class TestSquad::JasmineTest < Rails::Generators::TestCase
  tests TestSquad::InstallGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  setup do
    @destination_root = self.class.destination_root
    @gemfile_path = @destination_root.join('Gemfile').to_s
    FileUtils.rm_rf(@gemfile_path)
    FileUtils.touch(@gemfile_path)
  end

  teardown do
    FileUtils.rm_rf Rails.root.join('spec')
  end

  test 'skip rails assets source' do
    run_generator %w[--framework jasmine]
    refute File.read(@gemfile_path).include?("source 'https://rails-assets.org'")
  end

  test 'copy test_squad.rb' do
    run_generator %w[--framework jasmine]
    assert_file @destination_root.join('test/javascript/test_squad.rb'), /config.framework = 'jasmine'/
  end

  test 'create app dir' do
    run_generator %w[--framework jasmine]
    assert_directory @destination_root.join('test/javascript/dummy')
  end

  test 'create spec helper file' do
    run_generator %w[--framework jasmine]
    assert_file @destination_root.join('test/javascript/spec_helper.js')
  end

  test 'copy sample test file' do
    run_generator %w[--framework jasmine]
    assert_file @destination_root.join('test/javascript/dummy/answer_spec.js')
  end
end
