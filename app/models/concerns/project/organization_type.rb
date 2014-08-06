module Project::OrganizationType
  extend ActiveSupport::Concern

  included do
    class << self
      def organization_type_array
        organization_types.collect { |type| [I18n.t("project.organization_type.#{type}"), type] }
      end

      def organization_types
        [:academic, :advocacy, :archaeological, :community, :government, :museum, :university, :volunteer, :other]
      end
    end
  end
end
