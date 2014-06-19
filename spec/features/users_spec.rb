# coding: utf-8

require 'spec_helper'

describe "Users", js: true do
  before do
    OauthProvider.create! name: 'facebook', key: 'dummy_key', secret: 'dummy_secret'
  end

  describe "redirect to the last page after login" do
    before do
      @project = create(:project)
      visit project_path(@project)
      login
    end

    it { expect(current_path).to eq(project_path(@project)) }
  end
end
