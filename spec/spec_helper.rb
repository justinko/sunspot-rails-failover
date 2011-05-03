require 'rubygems'
require 'bundler'
Bundler.setup

require 'sunspot-rails-failover'

Dir['./spec/support/*.rb'].map {|f| require f }

RSpec.configure do |config|
  config.color_enabled = true
end