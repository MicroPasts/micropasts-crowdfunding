require 'spec_helper'

describe Channel::StateMachineHandler do

  describe "state machine" do
    let(:channel) { create(:channel, state: 'draft') }

    describe '#draft?' do
      subject { channel.draft? }
      context "when channel is new" do
        it { should be_true }
      end
    end

    describe '.push_to_draft' do
      subject do
        channel.push_to_online
        channel.push_to_draft
        channel
      end

      describe '#draft?' do
        subject { super().draft? }
        it { should be_true }
      end
    end

    describe '#push_to_online' do

      subject do
        channel.push_to_online
        channel
      end

      describe '#online?' do
        subject { super().online? }
        it { should be_true }
      end
    end

    describe '#online?' do
      before do
        channel.push_to_online
      end
      subject { channel.online? }
      it { should be_true }
    end

  end
end
