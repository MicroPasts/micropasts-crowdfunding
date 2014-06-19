require 'spec_helper'

describe Projects::FaqsController do
  let(:faq) { create(:project_faq) }
  let(:current_user) { nil }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  subject { response }

  describe "POST create" do
    before{ post :create, project_id: faq.project, locale: 'en', project_faq: {title: 'title', answer: 'answer'} }

    subject { ProjectFaq.where(project_id: faq.project) }

    context 'When user is a guest' do
      it'has 1 item' do
        expect(subject.size).to eq(1)
      end
    end

    context "When user is a registered user but don't the project owner" do
      let(:current_user){ create(:user) }
      it'has 1 item' do
        expect(subject.size).to eq(1)
      end
    end

    context 'When user is admin' do
      let(:current_user) { create(:user, admin: true) }
      it'has 2 itens' do
        expect(subject.size).to eq(2)
      end
    end

    context 'When user is project_owner' do
      let(:current_user) { faq.project.user }
      it'has 2 itens' do
        expect(subject.size).to eq(2)
      end
    end
  end

  describe "DELETE destroy" do
    before { delete :destroy, project_id: faq.project, id: faq.id, locale: 'en' }
    let(:total_faqs) { ProjectFaq.where(project_id: faq.project) }

    context 'When user is a guest' do
      describe '#status' do
        subject { super().status }
        it { should == 302 }
      end
      it { expect(total_faqs.size).to eq(1) }
    end

    context "When user is a registered user but don't the project owner" do
      let(:current_user){ create(:user) }

      describe '#status' do
        subject { super().status }
        it { should == 302 }
      end
      it { expect(total_faqs.size).to eq(1) }
    end

    context 'When user is admin' do
      let(:current_user) { create(:user, admin: true) }

      describe '#status' do
        subject { super().status }
        it { should == 302 }
      end
      it { expect(total_faqs.size).to eq(0) }
    end

    context 'When user is project_owner' do
      let(:current_user) { faq.project.user }

      describe '#status' do
        subject { super().status }
        it { should == 302 }
      end
      it { expect(total_faqs.size).to eq(0) }
    end
  end


end
