require 'spec_helper'

describe Concerns::SocialHelpersHandler do
  render_views
  before do
    [:render_facebook_sdk, :render_facebook_like, :render_twitter, :display_uservoice_sso].each do |method|
      allow_any_instance_of(ApplicationController).to receive(method).and_call_original
    end
    @controller = ApplicationController.new
    allow(@controller.request).to receive(:variant)
  end

  describe '#set_facebook_url_admin' do
    it 'assigns facebook_id\'s of the user in @facebook_url_admin' do
      @controller.set_facebook_url_admin(double('User', facebook_id: 1))
      expect(@controller.instance_variable_get(:@facebook_url_admin)).to eq(1)
    end
  end

  describe '#facebook_url_admin' do
    before { @controller.instance_variable_set(:@facebook_url_admin, 3) }

    it { expect(@controller.facebook_url_admin).to eq('3') }
  end

  describe '#render_facebook_sdk' do
    it { expect(@controller.render_facebook_sdk).to render_template(partial: 'layouts/_facebook_sdk') }
  end

  describe '#render_twitter' do
    let(:options) { { url: 'http://test.local', text: 'Foo Bar' } }
    it { expect(@controller.render_twitter(options)).to render_template(partial: 'layouts/_twitter') }
  end

  describe '#render_facebook_like' do
    let(:options) { { width: 300, href: 'http://test.local' } }
    it { expect(@controller.render_facebook_like(options)).to render_template(partial: 'layouts/_facebook_like') }
  end

  describe '#display_uservoice_sso' do
    let(:current_user) { create(:user) }
    before do
      @controller.request = OpenStruct.new(host: 'neighborly.local')

      allow(controller).to receive(:current_user).and_return(current_user)
    end

    it { expect(@controller.display_uservoice_sso).to_not be_nil }
  end
end
