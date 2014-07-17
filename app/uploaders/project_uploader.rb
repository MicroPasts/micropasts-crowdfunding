class ProjectUploader < ImageUploader
  process convert: :jpg

  version :project_thumb do
    process quality: 70
    process resize_to_fill: [228, 178]
  end

  version :_2x, from_version: :project_thumb do
    process quality: 100
  end

  version :project_thumb_large do
    process quality: 100
    process resize_to_fill: [495, 335]
  end

  #facebook requires a minimum thumb size
  version :project_thumb_facebook do
    process resize_to_fill: [512, 400]
  end
end
