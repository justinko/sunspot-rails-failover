require 'spec_helper'

require 'hoptoad_notifier'

describe Sunspot::Rails::Failover::ExceptionHandlerAdapter do
  describe '.handle' do
    let(:exception) { Exception.new }
    
    context 'for hoptoad' do
      before { Sunspot::Rails::Failover.exception_handler = :hoptoad }
      
      it 'uses the api' do
        HoptoadNotifier.should_receive(:notify).with(exception)
        described_class.handle(exception)
      end
    end
    
    context 'for a custom class' do
      before { Sunspot::Rails::Failover.exception_handler = MyExceptionHandler }
      
      it 'passes the exception to #handle' do
        MyExceptionHandler.should_receive(:handle).with(exception)
        described_class.handle(exception)
      end
    end
  end
end