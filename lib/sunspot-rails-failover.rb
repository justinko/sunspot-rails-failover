require 'sunspot'
require 'sunspot-rails-failover/master_slave_with_failover_session_proxy'
require 'sunspot-rails-failover/exception_handler_adapter'

module Sunspot
  module Rails
    module Failover
      class << self
        attr_accessor :exception_handler
        
        def setup
          Sunspot.session = if Sunspot::Rails.configuration.has_master?
            Sunspot::SessionProxy::MasterSlaveWithFailoverSessionProxy.new(
              Sunspot::Session.new(master_config), Sunspot::Session.new(slave_config)
            )
          else
            Sunspot::SessionProxy::ThreadLocalSessionProxy.new(slave_config)
          end
        end
        
      private
      
        def slave_config
          build_config('solr', 'url')
        end
        
        def master_config
          build_config('master_solr', 'url')
        end
        
        def build_config(*keys)
          Sunspot::Configuration.build.tap do |config|
            config.solr.url = Sunspot::Rails.configuration.send :user_configuration_from_key, *keys
          end
        end
      end
    end
  end
end