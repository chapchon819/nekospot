class ProcessImageJob
    include Sidekiq::Job

    sidekiq_options queue: :image_processing, retry: 5

    def perform(review_id)
        begin
        review = Review.find(review_id)
        rescue ActiveRecord::RecordNotFound => e
            logger.error "Review not found: #{e.message}. Retrying..."
            raise e
        end

        image_paths = review.images
    
        image_paths.each do |image_path|
        next if image_path.nil?

        begin
            # アップローダーをインスタンス化して画像パスを設定
            image_uploader = ImageUploader.new(review, :images)
            image_uploader.retrieve_from_store!(image_path)
            # 画像のバージョンを再生成
            image_uploader.recreate_versions!

            # 画像を保存
            image_uploader.store!
        rescue StandardError => e
            logger.error "Failed to process image #{image_path}: #{e.message}"
            next
        end
    end

        # 画像のパスを更新して保存
        review.update(images: image_paths)
    end

    private

    def logger
        @logger ||= Logger.new(STDOUT)
    end
end