require 'spec_helper'

describe 'sensu', :type => :class do
  let(:facts) { { :osfamily => 'RedHat' } }
  let(:log_messages) { [] }
  let(:log_collector) { Puppet::Test::LogCollector.new(log_messages) }

  before do
    Puppet::Util::Log.newdestination(log_collector)
  end

  after do
    Puppet::Util::Log.close(log_collector)
  end

  it 'should compile' do should create_class('sensu') end
  it { should contain_user('sensu') }

  context 'with manage_user => false' do
    let(:params) { {:manage_user => false} }
    it { should_not contain_user('sensu') }
  end

  context 'fail if dashboard parameter present' do
    let(:params) { {:dashboard => true} }
    it { expect { should create_class('sensu') }.to raise_error(/Sensu-dashboard is deprecated, use a dashboard module/) }
  end

  context 'with purge_config => true' do
    let(:params) { { :purge_config => true } }

    it 'should log a warning' do
      should compile

      expect(log_messages).to include(an_object_having_attributes(level: :warning, message: /purge_config is deprecated/))
    end

    context 'and purge parameter present' do
      let(:params) { { :purge_config => true, :purge => {} } }

      it 'should fail' do
        expect { should create_class('sensu') }.to raise_error(/purge_config is deprecated and cannot be used with purge, set the purge parameter to a hash containing `config => true` instead/)
      end
    end
  end

  context 'with purge_plugins_dir => true' do
    let(:params) { { :purge_plugins_dir => true } }

    it 'should log a warning' do
      should compile

      expect(log_messages).to include(an_object_having_attributes(level: :warning, message: /purge_plugins_dir is deprecated/))
    end

    context 'and purge parameter present' do
      let(:params) { { :purge_plugins_dir => true, :purge => {} } }

      it 'should fail' do
        expect { should create_class('sensu') }.to raise_error(/purge_plugins_dir is deprecated and cannot be used with purge, set the purge parameter to a hash containing `plugins => true` instead/)
      end
    end
  end

end



