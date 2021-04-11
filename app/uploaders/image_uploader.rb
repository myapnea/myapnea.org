# frozen_string_literal: true

# Generic uploader that removes the image name, but does no resizing.
class ImageUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :s3

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    File.join(
      model.class.to_s.underscore.pluralize,
      (Rails.env.test? ? model.slug : model.id.to_s),
      mounted_as.to_s
    )
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/assets/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Add a list of extensions which are allowed to be uploaded.
  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "image#{File.extname(original_filename)}" if original_filename
  end
end
