require 'spec_helper'

describe Project::StateMachineHandler do
  let(:user){ create(:user) }

  describe "state machine" do
    let(:project) { create(:project, state: 'draft', online_date: nil) }

    describe '#draft?' do
      subject { project.draft? }
      context "when project is new" do
        it { should be_true }
      end
    end

    describe '#approve' do
      before { project.push_to_draft }

      subject do
        expect(project).to receive(:notify_observers).with(:from_draft_to_soon)
        project.approve!
        project
      end

      it 'changes the state to soon' do
        expect(subject.soon?).to be_true
      end

      it('should call after transition method to notify the project owner'){ subject }
    end

    describe '.push_to_draft' do
      subject do
        project.reject
        project.push_to_draft
        project
      end

      describe '#draft?' do
        subject { super().draft? }
        it { should be_true }
      end
    end

    describe '#rejected?' do
      subject { project.rejected? }
      before do
        project.push_to_draft
        project.reject
      end
      context 'when project is not accepted' do
        it { should be_true }
      end
    end

    describe '#reject' do
      before { project.update_attributes state: 'draft' }
      subject do
        expect(project).to receive(:notify_observers).with(:from_draft_to_rejected)
        project.reject
        project
      end

      describe '#rejected?' do
        subject { super().rejected? }
        it { should be_true }
      end
    end

    describe '#push_to_trash' do
      let(:project) { create(:project, permalink: 'my_project', state: 'draft') }

      subject do
        project.push_to_trash
        project
      end

      describe '#deleted?' do
        subject { super().deleted? }
        it { should be_true }
      end

      describe '#permalink' do
        subject { super().permalink }
        it { should == "deleted_project_#{project.id}" }
      end
    end

    describe '#launch' do
      before { project.push_to_draft }

      subject do
        expect(project).to receive(:notify_observers).with(:from_draft_to_online)
        project.launch
        project
      end

      describe '#online?' do
        subject { super().online? }
        it { should be_true }
      end
      it('should call after transition method to notify the project owner'){ subject }
      it 'should persist the online_date' do
        project.launch
        expect(project.online_date).to_not be_nil
      end
    end

    describe '#online?' do
      before do
        project.push_to_draft
        project.launch
      end
      subject { project.online? }
      it { should be_true }
    end

    describe '#finish' do
      let(:main_project) { create(:project, goal: 30_000, online_days: -1) }
      subject { main_project }

      context 'when project is not online' do
        before do
          main_project.update_attributes state: 'draft'
        end

        describe '#finish' do
          subject { super().finish }
          it { should be_false }
        end
      end

      context 'when project is expired and the sum of the pending contributions and confirmed contributions dont reached the goal' do
        before do
          create(:contribution, value: 100, project: subject, created_at: 2.days.ago)
          subject.finish
        end

        describe '#failed?' do
          subject { super().failed? }
          it { should be_true }
        end
      end

      context 'when project is expired and have recent contributions without confirmation' do
        before do
          create(:contribution, value: 30_000, project: subject, state: 'waiting_confirmation')
          subject.finish
        end

        describe '#waiting_funds?' do
          subject { super().waiting_funds? }
          it { should be_true }
        end
      end

      context 'when project already hit the goal and passed the waiting_funds time' do
        before do
          main_project.update_attributes state: 'waiting_funds'
          allow(subject).to receive(:pending_contributions_reached_the_goal?).and_return(true)
          allow(subject).to receive(:reached_goal?).and_return(true)
          subject.online_date = 2.weeks.ago
          subject.online_days = 0
        end

        context "when campaign type is all_or_none" do
          before do
            subject.finish
          end

          describe '#successful?' do
            subject { super().successful? }
            it { should be_true }
          end
        end

        context "when campaign type is flexible" do
          before do
            main_project.update_attributes campaign_type: 'flexible'
            subject.finish
          end

          describe '#successful?' do
            subject { super().successful? }
            it { should be_true }
          end
        end
      end

      context 'when project already hit the goal and still is in the waiting_funds time' do
        before do
          allow(subject).to receive(:pending_contributions_reached_the_goal?).and_return(true)
          allow(subject).to receive(:reached_goal?).and_return(true)
          create(:contribution, project: main_project, user: user, value: 20, state: 'waiting_confirmation')
          main_project.update_attributes state: 'waiting_funds'
        end

        context "when project is all_or_none" do
          before do
            subject.finish
          end

          describe '#successful?' do
            subject { super().successful? }
            it { should be_false }
          end
        end

        context "when project is flexible" do
          before do
            main_project.update_attributes campaign_type: 'flexible'
            subject.finish
          end

          describe '#successful?' do
            subject { super().successful? }
            it { should be_false }
          end
        end
      end

      context 'when project not hit the goal' do
        let(:user) { create(:user) }
        let(:contribution) { create(:contribution, project: main_project, user: user, value: 20, payment_token: 'ABC') }

        before do
          contribution
          subject.online_date = 2.weeks.ago
          subject.online_days = 0
        end

        context "when project is all_or_none" do
          before do
            subject.finish
          end

          describe '#failed?' do
            subject { super().failed? }
            it { should be_true }
          end

          it "should generate credits for users" do
            contribution.confirm!
            user.reload
            expect(user.credits).to eq(20)
          end
        end

        context "when project is flexible" do
          before do
            subject.update_attributes campaign_type: 'flexible'
            subject.finish
          end

          describe '#failed?' do
            subject { super().failed? }
            it { should be_false }
          end

          it "should generate credits for users" do
            contribution.confirm!
            user.reload
            expect(user.credits).to eq(0)
          end
        end
      end
    end
  end
end
