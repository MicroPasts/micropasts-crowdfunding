require 'spec_helper'

describe Unsubscribe do
  describe 'associations' do
    it{ should belong_to :user }
    it{ should belong_to :project }
  end

  describe '.updates_unsubscribe' do
    subject{ Unsubscribe.updates_unsubscribe(1618) }
    it{ should_not be_persisted }

    describe '#class' do
      subject { super().class }
      it { should == Unsubscribe }
    end

    describe '#project_id' do
      subject { super().project_id }
      it { should == 1618 }
    end

    context 'when project_id is nil' do
      subject{ Unsubscribe.updates_unsubscribe(nil) }

      describe '#class' do
        subject { super().class }
        it { should == Unsubscribe }
      end

      describe '#project_id' do
        subject { super().project_id }
        it { should be_nil }
      end
    end
  end
end
