require 'spec_helper'

describe Project::OrganizationType do
  it { expect(Project.organization_types).to eq [:academic, :advocacy, :archaeological, :community, :government, :museum, :university, :volunteer, :other] }
  it { expect(Project.organization_type_array.size).to eq Project.organization_types.size }
end
