module Sunspot
  module Rails
    module Failover
      module ExceptionHandlerAdapter
      
        def self.handle(exception)
          case exception_handler
          when :hoptoad, nil
            require 'hoptoad_notifier'
            HoptoadNotifier.notify(exception)
          when Class
            exception_handler.handle(exception)
          end
        end
      
        def self.exception_handler
          Failover.exception_handler
        end
      
      end
    end
  end
end