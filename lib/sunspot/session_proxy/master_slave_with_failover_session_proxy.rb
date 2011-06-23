module Sunspot
  module SessionProxy
    class MasterSlaveWithFailoverSessionProxy < MasterSlaveSessionProxy  
      attr_accessor :exception
      
      def commit
        with_exception_handling do
          master_session.commit
        end
      end
      
      def search(*types, &block)
        result = with_exception_handling { slave_session.search(*types, &block) }
        result ||= with_exception_handling { master_session.search(*types, &block) }
        
        raise(exception) unless result
        result
      end
      
    private
    
      def with_exception_handling
        yield
      rescue Exception => exception
        Rails::Failover::ExceptionHandlerAdapter.handle(exception)
        self.exception = exception
        false
      end
      
    end
  end
end