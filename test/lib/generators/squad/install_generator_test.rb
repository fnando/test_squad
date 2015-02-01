require 'test_helper'
require 'generators/test_squad/install/install_generator'

class TestSquad::InstallGeneratorTest < Rails::Generators::TestCase
  tests TestSquad::InstallGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
