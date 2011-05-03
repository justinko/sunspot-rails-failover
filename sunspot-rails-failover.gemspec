# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'sunspot-rails-failover/version'

Gem::Specification.new do |s|
  s.name        = 'sunspot-rails-failover'
  s.version     = Sunspot::Rails::Failover::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = 'Justin Ko'
  s.email       = 'jko170@gmail.com'
  s.homepage    = 'https://github.com/justinko/sunspot-rails-failover'
  s.description = s.summary = 'Failover support for sunspot_rails'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path = 'lib'
  
  s.add_dependency 'sunspot_rails', '~> 1.2.1'
  
  s.add_development_dependency 'rspec', '~> 2.5'
  s.add_development_dependency 'hoptoad_notifier'
end