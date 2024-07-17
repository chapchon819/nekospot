class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include ::CarrierWave::Backgrounder::Delay

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # WebP変換を先に行い、その後リサイズ
  process :convert_to_webp
  process resize_to_limit: [1000, 667]

  version :thumb do
    process :convert_to_webp
    process resize_to_fit: [50, 50]
  end

  version :ogp do
    process :convert_to_webp
    process resize_to_fill: [1200, 630]
  end

  def extension_allowlist
    %w(jpg jpeg gif png webp)
  end

  def convert_to_webp
    manipulate! do |img|
      img.format 'webp'
      img
    end
  end

  def filename
    "#{super.chomp(File.extname(super))}.webp" if original_filename.present?
  end

  def fog_attributes
    { 'Cache-Control' => "max-age=#{365.day.to_i}", 'x-amz-acl' => 'public-read' }
  end

  def validate_max_files(files, max_files = 3)
    if files.size > max_files
      raise CarrierWave::IntegrityError, "画像は最高#{max_files} 枚まで投稿できます。"
    end
  end
end