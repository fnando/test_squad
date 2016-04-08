class TestSquadController < ActionController::Base
  def tests
    load Rails.root.join(TestSquad.test_directory, "test_squad.rb").to_s
    render TestSquad.configuration.framework
  end
end
