require 'spec_helper'

describe PaymentEngine do
  let(:creditcard)   { double('Balanced::Creditcard',  name: 'creditcard') }
  let(:bankaccount)  { double('Balanced::Bankaccount', name: 'bankaccount') }
  let(:contribution) { FactoryGirl.create(:contribution) }

  before { PaymentEngine.destroy_all }

  describe '.save' do
    it 'should save the engine' do
      PaymentEngine.new(creditcard).save
      expect(PaymentEngine.all).to eq [creditcard]
    end
  end

  describe '.destroy_all' do
    before { PaymentEngine.new(creditcard).save  }

    it 'should destroy all engines' do
      PaymentEngine.destroy_all
      expect(PaymentEngine.all).to be_empty
    end
  end

  describe '.configuration' do
    it 'should turn configuration class' do
      expect(PaymentEngine.configuration).to eq ::Configuration
    end
  end

  describe '.create_payment_notification' do
    it 'should create payment notification' do
      notification = PaymentEngine.create_payment_notification(
        resource_id: { contribution_id: contribution.id },
        extra_data:  { test: true }
      )
      expect(notification).to eql(PaymentNotification.where(contribution_id: contribution.id).first)
    end

    it 'prevents errors when trying to create notifications with string keys' do
      notification = PaymentEngine.create_payment_notification(
        resource_id: { 'contribution_id' => contribution.id },
        extra_data:  { test: true }
      )
      expect(notification).to eql(PaymentNotification.where(contribution_id: contribution.id).first)
    end
  end

  describe '.find_payment' do
    it 'filters by contribution attributes' do
      expect(
        described_class.find_payment(id: contribution.id)
      ).to eql(contribution)
    end

    it 'accepts filter by :contribution_id key' do
      expect(
        described_class.find_payment(contribution_id: contribution.id)
      ).to eql(contribution)
    end

    it 'accepts filter by :match_id key' do
      match = create(:match)
      expect(
        described_class.find_payment(match_id: match.id)
      ).to eql(match)
    end

    it 'returns nil when called with no filter' do
      expect(described_class.find_payment({})).to be_nil
    end
  end

  describe '.all' do
    before do
      PaymentEngine.new(creditcard).save
      PaymentEngine.new(bankaccount).save
    end

    it 'should return all engines' do
      expect(PaymentEngine.all).to eq [creditcard, bankaccount]
    end
  end

  after(:all) do
    PaymentEngine.destroy_all
  end
end
