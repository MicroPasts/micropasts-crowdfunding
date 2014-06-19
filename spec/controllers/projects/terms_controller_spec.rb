require 'spec_helper'

describe Projects::TermsController do
  let(:document) { create(:project_document) }
  let(:file) { File.open("#{Rails.root}/spec/fixtures/image.png") }
  let(:current_user) { nil }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  subject { response }

  describe "POST create" do
    before{ post :create, project_id: document.project, locale: 'en', project_document: { name: 'some name', document: file } }

    subject { ProjectDocument.where(project_id: document.project) }

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
      let(:current_user) { document.project.user }
      it'has 2 itens' do
        expect(subject.size).to eq(2)
      end
    end
  end

  describe "DELETE destroy" do
    before { delete :destroy, project_id: document.project, id: document, locale: 'en' }
    let(:total_documents) { ProjectDocument.where(project_id: document.project) }

    context 'When user is a guest' do
      describe '#status' do
        subject { super().status }
        it { should == 302 }
      end
      it { expect(total_documents.size).to eq(1) }
    end

    context "When user is a registered user but don't the project owner" do
      let(:current_user){ create(:user) }

      describe '#status' do
        subject { super().status }
        it { should == 302 }
      end
      it { expect(total_documents.size).to eq(1) }
    end

    context 'When user is admin' do
      let(:current_user) { create(:user, admin: true) }

      describe '#status' do
        subject { super().status }
        it { should == 302 }
      end
      it { expect(total_documents.size).to eq(0) }
    end

    context 'When user is project_owner' do
      let(:current_user) { document.project.user }

      describe '#status' do
        subject { super().status }
        it { should == 302 }
      end
      it { expect(total_documents.size).to eq(0) }
    end
  end


end
