require 'open-uri'
require 'json'

namespace :Spot do
    desc 'Update spot images from Google Places API'
    task :update_images => :environment do

        def fetch_photo_references(place_id)
            client = GooglePlaces::Client.new(API_KEY)
            place_detail_query = URI.encode_www_form(
                place_id: place_id,
                language: 'ja',
                key: API_KEY
            )
            place_detail_url = "https://maps.googleapis.com/maps/api/place/details/json?#{place_detail_query}"
            place_detail_page = URI.open(place_detail_url).read
            place_detail_data = JSON.parse(place_detail_page)

            photos = place_detail_data['result']['photos']
            photos.present? ? photos.map { |photo| photo['photo_reference'] }.take(5) : []
        rescue => e
            puts "APIリクエスト中にエラーが発生しました: #{e.message}"
            []
        end

        Spot.find_each do |spot|
            next if spot.place_id.blank?
            
            puts "-----------------------------"
            puts "画像を更新中: #{spot.name} (Place ID: #{spot.place_id})"
            photo_references = fetch_photo_references(spot.place_id)

            if photo_references.present?
                spot.spot_images.destroy_all # 既存の画像データを削除
                photo_references.each do |photo_reference|
                    has_cat = CatVision.image_analysis(photo_reference) # 猫が写っているかを判定
                    SpotImage.create!(spot: spot, image: photo_reference, cat: has_cat)
                end
                puts "画像を更新しました: #{spot.name}"
            else
                puts "新しい画像データが見つかりませんでした: #{spot.name}"
            end
        end
    end
end