require 'spec_helper'

require 'hoptoad_notifier'

shared_examples_for 'a hoptoad handler' do
  it 'uses the api' do
    HoptoadNotifier.should_receive(:notify).with(exception)
    described_class.handle(exception)
  end
end 

describe Sunspot::Rails::Failover::ExceptionHandlerAdapter do
  describe '.handle' do
    let(:exception) { Exception.new }
    
    context 'with exception_handler not set (default)' do
      it_should_behave_like 'a hoptoad handler'
    end
    
    context 'with exception_handler set to :hoptoad' do
      before { Sunspot::Rails::Failover.exception_handler = :hoptoad }
      it_should_behave_like 'a hoptoad handler'
    end
  
    context 'with exception_handler set to a custom class' do
      before { Sunspot::Rails::Failover.exception_handler = MyExceptionHandler }
      
      it 'passes the exception to #handle' do
        MyExceptionHandler.should_receive(:handle).with(exception)
        described_class.handle(exception)
      end
    end
  end
end