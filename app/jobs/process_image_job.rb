class ProcessImageJob
    include Sidekiq::Job
  
    sidekiq_options queue: :image_processing

    sidekiq_options queue: :image_processing

    def perform(review_id)
        review = Review.find(review_id)
        image_paths = review.images
    
        image_paths.each do |image_path|
            # アップローダーをインスタンス化して画像パスを設定
            image_uploader = ImageUploader.new(review, :images)
            image_uploader.retrieve_from_store!(image_path)
    
            # 画像のバージョンを再生成
            image_uploader.recreate_versions!
    
            # 画像を保存
            image_uploader.store!
        end
    
        # 画像のパスを更新して保存
        review.update(images: image_paths)
    end
end