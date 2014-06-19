require 'spec_helper'

describe NotificationsMailer do
  subject { described_class.notify(notification) }

  describe '.notify' do
    context 'when there is no bcc' do
      let(:notification){ create(:notification,
                                 template_name: 'payment_confirmed',
                                 user: create(:user, locale: 'pt'),
                                 origin_name: 'Catarse',
                                 origin_email: 'contact@foo.bar') }

      before do
        notification
        allow_any_instance_of(Mail::Message).to receive(:deliver)
        expect_any_instance_of(described_class).to receive(:mail).with({
          from: 'Catarse <contact@foo.bar>',
          to: notification.user.email,
          subject: 'Thank you for your contribution to Foo bar!',
          template_name: 'payment_confirmed'
        })
      end

      it('should satisfy expectations') { subject }
    end

    context 'when there is a bcc' do
      let(:notification){ create(:notification,
                                 template_name: 'payment_confirmed',
                                 user: create(:user, locale: 'pt'),
                                 origin_name: 'Catarse',
                                 origin_email: 'contact@foo.bar',
                                 bcc: 'test@bcc.com') }

      before do
        notification
        allow_any_instance_of(Mail::Message).to receive(:deliver)
        expect_any_instance_of(described_class).to receive(:mail).with({
          from: 'Catarse <contact@foo.bar>',
          to: notification.user.email,
          subject: 'Thank you for your contribution to Foo bar!',
          template_name: 'payment_confirmed',
          bcc: 'test@bcc.com'
        })
      end

      it('should satisfy expectations') { subject }
    end
  end
end
