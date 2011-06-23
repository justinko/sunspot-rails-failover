require 'spec_helper'

module Sunspot
  module SessionProxy
    describe MasterSlaveWithFailoverSessionProxy do
      let(:master) { Session.new }
      let(:slave) { Session.new }
      let(:proxy) { SessionProxy::MasterSlaveWithFailoverSessionProxy.new(master, slave) }
  
      let(:exception_handler_adapter) { Rails::Failover::ExceptionHandlerAdapter }
  
      describe '#commit' do
        context 'with no error' do
          it 'calls on the master session' do
            master.should_receive(:commit)
            proxy.commit
          end
        end
    
        context 'with an error' do
          it 'passes the exception to the exception handler adapter' do
            exception = Exception.new
            exception_handler_adapter.should_receive(:handle).with(exception)
            master.should_receive(:commit).and_raise(exception)
            proxy.commit
          end
        end
      end
  
      describe '#search' do
        context 'with no error' do
          it 'calls on the slave session' do
            slave.should_receive(:search).and_return(true)
            master.should_not_receive(:search)
            proxy.search
          end
          
          it "returns a Sunspot::Search::StandardSearch object" do
            connection = double
            connection.stub(:request)
            Sunspot::Session.any_instance.stub(:connection).and_return(connection)
            result = proxy.search(Searchable)
            result.should be_a(Sunspot::Search::StandardSearch)
          end
        end
    
        context 'with an error on the slave session' do
          it 'calls on the master session' do
            exception = Exception.new
            slave.should_receive(:search).and_raise(exception)
            exception_handler_adapter.should_receive(:handle).with(exception)
            master.should_receive(:search).and_return(true)
            proxy.search
          end
        end
    
        context 'with an error on the slave and master sessions' do
          it 'raises the error with no handling' do
            exception = Exception.new
            slave.should_receive(:search).and_raise(exception)
            master.should_receive(:search).and_raise(exception)
            exception_handler_adapter.should_receive(:handle).with(exception).twice
            proxy.should_receive(:raise).with(exception)
            proxy.search
          end
        end
      end
      
    end
  end
end
