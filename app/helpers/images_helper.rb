module ImagesHelper
  def image_tag_with_steroids(image_attribute, default_version, options = {})
    #image_attribute = p.uploaded_image
    #default_version = :project_thumb_large
    versions = image_attribute.class.versions.keys
    extra_versions = versions.select do |name|
      name != default_version && name.to_s[default_version.to_s]
    end

    extra_versions.map do |version|
      
    end
    "#{project.display_image("#{image_version}_2x")} 2x"
    image_tag()
  end
end
