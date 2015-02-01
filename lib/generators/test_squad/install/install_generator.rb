class TestSquad::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  class_option :framework,
    type: 'string',
    desc: 'Select the JavaScript framework. Can be jasmine, qunit, mocha or ember.',
    aliases: '-f',
    required: true

  def generate
    send "generate_#{options[:framework]}"
  end

  def generate_defaults
    add_source 'https://rails-assets.org'
    empty_directory test_directory
    template 'test_squad.rb.erb', "#{test_directory}/test_squad.rb"
  end

  private

  def test_directory
    TestSquad.test_directory
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
    template 'qunit/test_helper.js.erb', "#{test_directory}/test_helper.js"
    copy_file 'qunit/answer_test.js', "#{test_directory}/#{app_name}/answer_test.js"

    gem_group :development, :test do
      gem 'rails-assets-qunit'
    end
  end

  def generate_jasmine
    empty_directory "#{test_directory}/#{app_name}"
    create_file "#{test_directory}/#{app_name}/.keep"
    template 'jasmine/spec_helper.js.erb', "#{test_directory}/spec_helper.js"
    copy_file 'jasmine/answer_spec.js', "#{test_directory}/#{app_name}/answer_spec.js"
  end

  def generate_mocha
    empty_directory "#{test_directory}/#{app_name}"
    create_file "#{test_directory}/#{app_name}/.keep"
    template 'mocha/spec_helper.js.erb', "#{test_directory}/spec_helper.js"
    copy_file 'mocha/answer_spec.js', "#{test_directory}/#{app_name}/answer_spec.js"

    gem_group :development, :test do
      gem 'rails-assets-mocha'
      gem 'rails-assets-expect'
    end
  end

  def generate_ember
    empty_directory "#{test_directory}/unit"
    copy_file 'ember/router_test.js', "#{test_directory}/unit/router_test.js"

    empty_directory "#{test_directory}/routes"
    create_file "#{test_directory}/routes/.keep"

    empty_directory "#{test_directory}/components"
    create_file "#{test_directory}/components/.keep"

    empty_directory "#{test_directory}/views"
    create_file "#{test_directory}/views/.keep"

    empty_directory "#{test_directory}/models"
    create_file "#{test_directory}/models/.keep"

    template 'ember/test_helper.js.erb', "#{test_directory}/test_helper.js"

    gem_group :development, :test do
      gem 'rails-assets-qunit'
    end
  end
end
