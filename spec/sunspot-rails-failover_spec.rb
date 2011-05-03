require 'spec_helper'

describe Sunspot::Rails::Failover do
  describe '.setup' do
    context 'with a master configuration' do
      before do
        Sunspot::Rails.configuration.should_receive(:has_master?).and_return(true)
      end
      
      it 'sets the session to master/slave with failover support' do
        described_class.setup
        Sunspot.session.should be_an_instance_of(MasterSlaveWithFailoverSessionProxy)
      end
    end
  end
end