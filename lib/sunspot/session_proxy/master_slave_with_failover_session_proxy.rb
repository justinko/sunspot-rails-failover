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
        [slave_session, master_session].any? do |session|
          with_exception_handling { session.search(*types, &block) }
        end or raise(exception)
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