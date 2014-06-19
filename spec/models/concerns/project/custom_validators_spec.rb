require 'spec_helper'

describe Project::CustomValidators do
  describe '#permalink_on_routes?' do
    it 'should allow a unique permalink' do
      expect(Project.permalink_on_routes?('permalink_test')).to be_false
    end

    it 'should not allow a permalink to be one of catarse\'s routes' do
      expect(Project.permalink_on_routes?('projects')).to be_true
    end
  end
end
