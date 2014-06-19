require 'spec_helper'

describe Projects::UpdatesController do
  let(:update){ FactoryGirl.create(:update) }
  let(:current_user){ nil }
  before{ allow(controller).to receive(:current_user).and_return(current_user) }
  subject{ response }

  describe "GET index" do
    before{ get :index, project_id: update.project, locale: 'pt', format: 'html' }

    describe '#status' do
      subject { super().status }
      it { should == 200 }
    end
  end

  describe "DELETE destroy" do
    before { delete :destroy, project_id: update.project, id: update.id, locale: 'pt' }
    context 'When user is a guest' do
      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "When user is a registered user but don't the project owner" do
      let(:current_user){ FactoryGirl.create(:user) }
      it { expect(response).to redirect_to(root_path) }
    end

    context 'When user is admin' do
      let(:current_user) { FactoryGirl.create(:user, admin: true) }
      it { expect(response).to redirect_to(project_updates_path(update.project)) }
    end

    context 'When user is project_owner' do
      let(:current_user) { update.project.user }
      it { expect(response).to redirect_to(project_updates_path(update.project)) }
    end
  end

  describe "POST create" do
    before{ post :create, project_id: update.project, locale: 'pt', update: {title: 'title', comment: 'update comment'} }
    context 'When user is a guest' do
      it{ expect(Update.where(project_id: update.project).count).to eq(1)}
    end

    context "When user is a registered user but don't the project owner" do
      let(:current_user){ FactoryGirl.create(:user) }
      it{ expect(Update.where(project_id: update.project).count).to eq(1)}
    end

    context 'When user is admin' do
      let(:current_user) { FactoryGirl.create(:user, admin: true) }
      it{ expect(Update.where(project_id: update.project).count).to eq(2)}
    end

    context 'When user is project_owner' do
      let(:current_user) { update.project.user }
      it{ expect(Update.where(project_id: update.project).count).to eq(2)}
    end
  end
end
