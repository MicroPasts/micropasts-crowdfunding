require 'spec_helper'

describe Channels::ProfilesController do
  subject{ response }
  let(:channel){ FactoryGirl.create(:channel) }

  describe "GET show" do
    before do
      allow(request).to receive(:subdomain).and_return(channel.permalink)
      get :show, id: 'sample'
    end

    describe '#status' do
      subject { super().status }
      it { should == 200 }
    end
  end
end

