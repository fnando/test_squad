module TestSquad
  class Engine < ::Rails::Engine
    initializer "test_squad" do
      next unless %w[development test].include?(Rails.env)

      config = Rails.application.config

      config.assets.paths += [
        Rails.root.join(TestSquad.test_directory).to_s
      ]

      config.assets.precompile += %W[
        test_helper.js
        spec_helper.js

        test_squad/qunit-phantom.js
        test_squad/jasmine-phantom.js
        test_squad/mocha-phantom.js
        test_squad/ember.css
        test_squad/mocha-reporter.js

        qunit.css
        qunit.js

        jasmine/jasmine_favicon.png
        jasmine/jasmine.js
        jasmine/jasmine.css
        jasmine/jasmine-html.js
        jasmine/boot.js

        mocha.js
        mocha.css
      ]
    end
  end
end
