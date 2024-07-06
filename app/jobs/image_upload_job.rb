class ImageUploadJob < ApplicationJob
    queue_as :default

    def perform(image)
        uploader = ImageUploader.new
        uploader.store!(image)
    end
end