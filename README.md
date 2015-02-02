# TestSquad

[![Build Status](https://travis-ci.org/fnando/test_squad.svg)](https://travis-ci.org/fnando/test_squad)
[![Code Climate](https://codeclimate.com/github/fnando/test_squad/badges/gpa.svg)](https://codeclimate.com/github/fnando/test_squad)
[![Test Coverage](https://codeclimate.com/github/fnando/test_squad/badges/coverage.svg)](https://codeclimate.com/github/fnando/test_squad)

Running JavaScript tests on your Rails app, the easy way.

- Supports [QUnit](http://qunitjs.com), [Ember.js](http://emberjs.com), [Mocha](http://mochajs.org) and [Jasmine](http://jasmine.github.io/)
- Go headless with [Phantom.js](http://phantomjs.org)
- Colored output
- Asset pipeline support
- [Rails Assets](http://rails-assets.org) support (Bower Proxy)

## Installation

Add these lines to your application's `Gemfile`:

```ruby
group :development, :test do
  gem 'test_squad'
end
```

And then execute:

```console
$ bundle
```

## Usage

After installing TestSquad, generate your tests skeleton. The generator will detect if you're using RSpec or TestUnit and will generate the `javascript` directory basead on that detection. Just use the command `rails generate test_squad:install --framework FRAMEWORK`.

```console
$ rails generate test_squad:install --framework jasmine
    create  test/javascript/squad_sample
    create  test/javascript/squad_sample/.keep
    create  test/javascript/spec_helper.js
    source  https://rails-assets.org
     exist  test/javascript
    create  test/javascript/test_squad.rb
```

## Running tests

You can run your tests with `rake test_squad`. You can also visit `http://localhost:3000/tests` for in-browser testing.

![Jasmine](https://github.com/fnando/test_squad/raw/master/screenshots/jasmine.png)

![Mocha](https://github.com/fnando/test_squad/raw/master/screenshots/mocha.png)

![QUnit](https://github.com/fnando/test_squad/raw/master/screenshots/qunit.png)

![Terminal](https://github.com/fnando/test_squad/raw/master/screenshots/terminal.png)

![Ember](https://github.com/fnando/test_squad/raw/master/screenshots/terminal-ember.png)

### Configure Ember

When using the Ember framework, you must configure your application name. It'll default to your Rails application name.

```javascript
//= require application
//= require_self
//= require_tree ./components
//= require_tree ./models
//= require_tree ./routes
//= require_tree ./unit
//= require_tree ./views

// Set the application.
App = SquadSample;

// Set up Ember testing.
App.rootElement = '#ember-testing';
App.setupForTesting();
App.injectTestHelpers();
```

To disable all Ember logging, add the following line to `test_helper.js`, just before the `//= require application` line.

```javascript
//= require ./logging
```

Then create the file `spec/javascript/logging.js` with this content:

```javascript
Ember = {ENV: {
  LOG_TRANSITIONS: false,
  LOG_VIEW_LOOKUPS: false,
  LOG_ACTIVE_GENERATION: false,
  LOG_RESOLVER: false,
  LOG_TRANSITIONS: false,
  LOG_TRANSITIONS_INTERNAL: false,
  LOG_VERSION: false
}};
```

### Configure Mocha

By default, Mocha is configured with [expect.js](https://github.com/Automattic/expect.js). You can use different libraries like [should.js](https://github.com/visionmedia/should.js) or [chai](http://chaijs.com/).

Just add the dependency to your `Gemfile`. Use `rails-assets-chai` or `rails-assets-should`:

```ruby
source 'https://rubygems.org'
source 'https://rails-assets.org'

gem 'rails', '4.2.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'ember-rails'
gem 'rails-assets-jquery'

group :development, :test do
  gem 'test_squad', path: '../../test_squad'
  gem 'rails-assets-mocha'
  gem 'rails-assets-chai'
end
```

Install the dependency with `bundle install`. Then require the library on `{test/spec}/javascript/spec_helper.js`.

```javascript
//= require application
//= require chai
//= require_self
//= require_tree ./squad_sample

var assert = chai.assert;

mocha.setup('bdd');
mocha.checkLeaks();
mocha.globals(['jQuery']);
mocha.reporter(mocha.TestSquad);
window.onload = function(){
  mocha.run();
};
```

## Troubleshooting

If you have a catch-all route, add the following line to your `config/routes.rb` file. This will be required if you configure Ember.js to use `history.pushState`.

```ruby
get :tests, to: 'test_squad#tests' unless Rails.env.production?
```

Otherwise you won't be able to to run your in-browser tests.

## Configuration

The rake task accepts some env variables.

- `TEST_SQUAD_SERVER_HOST`: the binding host. Defaults to `localhost`.
- `TEST_SQUAD_SERVER_PORT`: the server port. Defaults to `50000`.
- `TEST_SQUAD_SERVER_PATH`: the server path. Defaults to `/tests`.
- `TEST_SQUAD_TIMEOUT`: how much time a test can take. Defaults to `10` (seconds).
- `TEST_SQUAD_PHANTOMJS_BIN`: set the PhantomJS binary. Defaults to `phantomjs`.

You can configure these options using the `{test,spec}/javascript/test_squad.rb` file.

```ruby
TestSquad.configure do |config|
  config.framework = 'qunit'
  config.server_host = '127.0.0.1'
  config.server_port = 50000
  config.server_path = '/tests'
  config.timeout = 10
  config.phantomjs_bin = 'phantomjs'
end
```

## Contributing

Before starting, create an issue asking if it'd be a useful/wanted feature. This will avoid wasting your time.

1. Fork it ( http://github.com/fnando/test_squad/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Remember:

- Don't mess with versioning.
- Follow the code style already present.
- Opening an issue asking if your feature/change will be welcomed it's recommended. That way you don't waste your time.

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
