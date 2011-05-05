require 'sunspot'
require 'sunspot/session_proxy/master_slave_with_failover_session_proxy'
require 'sunspot/rails/failover/exception_handler_adapter'

module Sunspot
  module Rails
    module Failover
      class << self
        attr_accessor :exception_handler
        
        def setup
          Sunspot.session = if Rails.configuration.has_master?
            SessionProxy::MasterSlaveWithFailoverSessionProxy.new(
              SessionProxy::ThreadLocalSessionProxy.new(master_config),
              SessionProxy::ThreadLocalSessionProxy.new(slave_config)
            )
          else
            SessionProxy::ThreadLocalSessionProxy.new(slave_config)
          end
        end
        
      private
      
        def slave_config
          Rails.send :slave_config, Rails.configuration
        end
        
        def master_config
          Rails.send :master_config, Rails.configuration
        end
      end
    end
  end
end