require "test_helper"

class TestSquadControllerTest < ActionController::TestCase
  def create_helper_file(framework)
    File.open(@destination_root.join("test_squad.rb"), "w") do |file|
      file << "TestSquad.configuration.framework = '#{framework}'"
    end
  end

  setup do
    @destination_root = Rails.root.join("test/javascript")
    FileUtils.mkdir_p(@destination_root)
  end

  teardown do
    FileUtils.rm_rf @destination_root
  end

  test "view for mocha framework" do
    create_helper_file "mocha"
    get :tests

    assert_response :ok
    assert_template "mocha"
  end

  test "view for jasmine framework" do
    create_helper_file "jasmine"
    get :tests

    assert_response :ok
    assert_template "jasmine"
  end

  test "view for qunit framework" do
    create_helper_file "qunit"
    get :tests

    assert_response :ok
    assert_template "qunit"
  end

  test "view for ember framework" do
    create_helper_file "ember"
    get :tests

    assert_response :ok
    assert_template "ember"
  end
end
