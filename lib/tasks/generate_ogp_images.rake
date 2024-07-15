namespace :spot do
    desc "スポット詳細のOGP画像を生成"
    task generate_ogp_images: :environment do
        include Rails.application.routes.url_helpers
    
        host = Rails.env.production? ? 'https://nekospot.jp' : 'http://localhost:3000'
    
        spot_id = ENV['SPOT_ID']
    
        if spot_id
            spot = Spot.includes(:spot_images).find_by(id: spot_id)
    
            if spot.nil?
            puts "スポットID: #{spot_id} は存在しません"
            elsif spot.spot_images.any? { |image| image.image.present? } && spot.ogp_image.blank?
            prioritized_image = spot.prioritized_spot_image
    
            if prioritized_image && prioritized_image.image.present?
                proxy_image_url = proxy_image_url(photo_reference: prioritized_image.image, host: host)
    
                begin
                spot.process_image(proxy_image_url)
                spot.save!
                puts "OGP画像が生成されました。スポットID: #{spot.id}"
                puts "----------"
                rescue => e
                puts "スポットID: #{spot.id} のOGP画像生成に失敗しました - エラー: #{e.message}"
                puts "----------"
                end
            else
                puts "有効な優先画像が見つかりません。スポットID: #{spot.id}"
                puts "----------"
            end
            end
        else
            Spot.includes(:spot_images).find_each do |spot|
            if spot.spot_images.any? { |image| image.image.present? } && spot.ogp_image.blank?
                prioritized_image = spot.prioritized_spot_image
    
                if prioritized_image && prioritized_image.image.present?
                proxy_image_url = proxy_image_url(photo_reference: prioritized_image.image, host: host)
    
                begin
                    spot.process_image(proxy_image_url)
                    spot.save!
                    puts "OGP画像が生成されました。スポットID: #{spot.id}"
                    puts "----------"
                rescue => e
                    puts "スポットID: #{spot.id} のOGP画像生成に失敗しました - エラー: #{e.message}"
                    puts "----------"
                end
                else
                puts "有効な優先画像が見つかりません。スポットID: #{spot.id}"
                puts "----------"
                end
            end
            end
        end
    end
end