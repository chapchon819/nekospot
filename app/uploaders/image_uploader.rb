class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog # 本番環境ではfogを使用
  else
    storage :file # 開発環境とテスト環境ではfileを使用
  end
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  process resize_to_limit: [1000, 667]
  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [50, 50]
  end

  version :ogp do
    process resize_to_fill: [1200, 630] # OGP推奨サイズ
  end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w(jpg jpeg gif png webp)
  end

  process :convert_to_webp

  def convert_to_webp
    manipulate! do |img|
      img.format 'webp'
      img
    end
  end

  def filename
    super.chomp(File.extname(super)) + '.webp' if original_filename.present?
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg"
  # end
  def validate_max_files(files, max_files = 3)
    if files.size > max_files
      raise CarrierWave::IntegrityError, "画像は最高#{max_files} 枚まで投稿できます。"
    end
  end
end
