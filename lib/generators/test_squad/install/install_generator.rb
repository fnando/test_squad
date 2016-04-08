require "test_squad"

module TestSquad
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    SKIP_RAILS_ASSETS = %w[jasmine]

    class_option :framework,
      type: "string",
      desc: "Select the JavaScript framework. Can be jasmine, qunit, mocha or ember.",
      aliases: "-f",
      required: true

    class_option :skip_source,
      type: "boolean",
      desc: "Skip adding gem source to Gemfile",
      aliases: "-s"

    def generate
      send "generate_#{framework}"
    end

    def generate_defaults
      empty_directory test_directory
      template "test_squad.rb.erb", "#{test_directory}/test_squad.rb"
    end

    private

    def framework
      options[:framework]
    end

    def test_directory
      if File.exist?(File.join(destination_root, "spec"))
        "spec/javascript"
      else
        "test/javascript"
      end
    end

    def app_name
      app_class_name.underscore
    end

    def app_class_name
      TestSquad.app_class_name
    end

    def generate_qunit
      empty_directory "#{test_directory}/#{app_name}"
      create_file "#{test_directory}/#{app_name}/.keep"
      template "qunit/test_helper.js.erb", "#{test_directory}/test_helper.js"
      copy_file "qunit/answer_test.js", "#{test_directory}/#{app_name}/answer_test.js"

      rails_assets do
        gem "rails-assets-qunit"
      end unless options[:skip_source]
    end

    def generate_jasmine
      empty_directory "#{test_directory}/#{app_name}"
      create_file "#{test_directory}/#{app_name}/.keep"
      template "jasmine/spec_helper.js.erb", "#{test_directory}/spec_helper.js"
      copy_file "jasmine/answer_spec.js", "#{test_directory}/#{app_name}/answer_spec.js"
    end

    def generate_mocha
      empty_directory "#{test_directory}/#{app_name}"
      create_file "#{test_directory}/#{app_name}/.keep"
      template "mocha/spec_helper.js.erb", "#{test_directory}/spec_helper.js"
      copy_file "mocha/answer_spec.js", "#{test_directory}/#{app_name}/answer_spec.js"

      rails_assets do
        gem_group :development, :test do
          gem "rails-assets-mocha"
          gem "rails-assets-expect"
        end
      end unless options[:skip_source]
    end

    def generate_ember
      empty_directory "#{test_directory}/unit"
      copy_file "ember/router_test.js", "#{test_directory}/unit/router_test.js"

      empty_directory "#{test_directory}/routes"
      create_file "#{test_directory}/routes/.keep"

      empty_directory "#{test_directory}/components"
      create_file "#{test_directory}/components/.keep"

      empty_directory "#{test_directory}/views"
      create_file "#{test_directory}/views/.keep"

      empty_directory "#{test_directory}/models"
      create_file "#{test_directory}/models/.keep"

      template "ember/test_helper.js.erb", "#{test_directory}/test_helper.js"

      rails_assets do
        gem_group :development, :test do
          gem "rails-assets-qunit"
        end
      end unless options[:skip_source]
    end

    def rails_assets(&block)
      in_root do
        append_file "Gemfile", %[\nsource "https://rails-assets.org" do], force: true

        instance_eval(&block)

        append_file "Gemfile", "\nend\n", force: true
      end
    end
  end
end
