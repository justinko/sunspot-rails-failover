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
              SessionProxy::ThreadLocalSessionProxy.new(master_config),
              SessionProxy::ThreadLocalSessionProxy.new(slave_config)
            )
          else
            Sunspot::SessionProxy::ThreadLocalSessionProxy.new(slave_config)
          end
        end
        
      private
      
        def slave_config
          Sunspot::Rails.send :slave_config, Sunspot::Rails.configuration
        end
        
        def master_config
          Sunspot::Rails.send :master_config, Sunspot::Rails.configuration
        end
      end
    end
  end
end