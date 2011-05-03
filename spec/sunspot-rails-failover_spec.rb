require 'spec_helper'

describe Sunspot::Rails::Failover do
  describe '.setup' do
    let(:configuration) { double('configuration') }
    
    before do
      Sunspot::Rails.stub(:configuration).and_return(configuration)
      configuration.should_receive(:user_configuration_from_key).with('solr', 'url')
    end
    
    context 'with a master configuration' do
      before do
        configuration.should_receive(:has_master?).and_return(true)
        configuration.should_receive(:user_configuration_from_key).with('master_solr', 'url')
      end
      
      it 'sets the session to master/slave with failover support' do
        described_class.setup
        Sunspot.session.should be_an_instance_of(Sunspot::SessionProxy::MasterSlaveWithFailoverSessionProxy)
      end
    end
    
    context 'with no master configuration' do
      before do
        configuration.should_receive(:has_master?).and_return(false)
      end
          
      it 'sets the session to the default' do
        described_class.setup
        Sunspot.session.should be_an_instance_of(Sunspot::SessionProxy::ThreadLocalSessionProxy)
      end
    end
    
  end
end