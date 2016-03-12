desc "Run JavaScript tests"
task :test_squad do
  ENV["RAILS_ENV"] = "test"
  ENV["RACK_ENV"] = "test"

  require "./config/environment"
  config_file = Rails.root.join(TestSquad.test_directory, "test_squad.rb")
  load config_file if config_file.exist?

  TestSquad::Runner.run
end
