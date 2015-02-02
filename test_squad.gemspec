require './lib/test_squad/version'

Gem::Specification.new do |s|
  s.name        = 'test_squad'
  s.version     = TestSquad::VERSION
  s.authors     = ['Nando Vieira']
  s.email       = ['fnando.vieira@gmail.com']
  s.homepage    = 'http://github.com/fnando/test_squad'
  s.summary     = 'Rails and JavaScript testing, the easy way. Supports QUnit, Jasmine, Mocha and Ember.'
  s.description = s.summary
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib,phantomjs,vendor}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails'
  s.add_development_dependency 'pry-meta'
end
