require 'spec_helper'

describe Notification do
  let(:contribution){ create(:contribution) }

  before do
    Sidekiq::Testing.fake!
    allow(Notification).to receive(:notify).and_call_original
    allow(Notification).to receive(:notify_once).and_call_original
    ActionMailer::Base.deliveries.clear
  end

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :project }
    it { should belong_to :channel }
    it { should belong_to :contribution }
    it { should belong_to :match }
    it { should belong_to :company_contact }
    it { should belong_to :project_update }
  end

  describe "#deliver" do
    let(:deliver_exception){ nil }
    let(:notification){ create(:notification, dismissed: false) }

    before do
      NotificationWorker.jobs.clear
      deliver_exception
      notification.deliver
    end

    context "when dismissed is true" do
      let(:notification){ create(:notification, dismissed: true) }
      it("should not add the notification into queue") { expect(NotificationWorker.jobs).to be_empty }
    end

    context "when dismissed is false" do
      it("should add the notification into queue") { expect(NotificationWorker.jobs).not_to be_empty }
    end
  end

  describe ".notify" do
    let(:notification){ build(:notification) }
    let(:notify){ Notification.notify(notification.template_name, notification.user) }
    before do
      expect(Notification).to receive(:create!).with({
        template_name: notification.template_name,
        user: notification.user,
        locale: notification.user.locale,
        origin_email: Configuration[:email_contact],
        origin_name: Configuration[:company_name]
      }).and_return(notification)
      expect(notification).to receive(:deliver)
    end
    it("should create and send email"){ notify }
  end

  describe ".notify_once" do
    let(:notification){ create(:notification) }
    let(:notify_once){ Notification.notify_once(notification.template_name, notification.user, filter) }

    context "when filter is nil" do
      let(:filter){ nil }
      before do
        expect(Notification).to receive(:notify).with(notification.template_name, notification.user, {})
      end
      it("should call notify"){ notify_once }
    end

    context "when filter returns a previous notification" do
      let(:filter){ { user_id: notification.user.id } }
      before do
        expect(Notification).not_to receive(:notify)
      end
      it("should call not notify"){ notify_once }
    end

    context "when filter does not return a previous notification" do
      let(:filter){ { user_id: (notification.user.id + 1) } }
      before do
        expect(Notification).to receive(:notify).with(notification.template_name, notification.user, {})
      end
      it("should call notify"){ notify_once }
    end
  end

end
