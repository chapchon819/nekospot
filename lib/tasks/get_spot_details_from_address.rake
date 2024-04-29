require 'csv'
require 'open-uri'
require 'json'
API_KEY = ENV['GMAP_API_KEY']

namespace :Spot do
  desc 'Fetch and save spot details from address'
  task :get_and_save_from_address => :environment do
    def get_place_id_by_address(address)
      client = GooglePlaces::Client.new(API_KEY)
      spot = client.spots_by_query(address).first
      spot.place_id if spot
    end

    def get_detail_data(spot)
      place_id = get_place_id_by_address(spot['住所'])

      if place_id
        existing_spot = Spot.find_by(place_id: place_id) # データベース内を検索
        if existing_spot
          puts "既に保存済みです: #{spot['店名']}"
          return nil
        end

        place_detail_query = URI.encode_www_form(
          place_id: place_id,
          language: 'ja',
          key: API_KEY
        )
        place_detail_url = "https://maps.googleapis.com/maps/api/place/details/json?#{place_detail_query}"
        place_detail_page = URI.open(place_detail_url).read
        place_detail_data = JSON.parse(place_detail_page)

        result = {}
        result[:name] = spot['店名']
        result[:postal_code] = place_detail_data['result']['address_components'].find { |c| c['types'].include?('postal_code') }&.fetch('long_name', nil)

        full_address = place_detail_data['result']['formatted_address']
        result[:address] = full_address.sub(/\A[^ ]+/, '')

        result[:phone_number] = place_detail_data['result']['formatted_phone_number']
        result[:opening_hours] = place_detail_data['result']['opening_hours']['weekday_text'].join("\n") if place_detail_data['result']['opening_hours'].present?
        result[:latitude] = place_detail_data['result']['geometry']['location']['lat']
        result[:longitude] = place_detail_data['result']['geometry']['location']['lng']
        result[:place_id] = place_id
        result[:web_site] = place_detail_data['result']['website']
        result[:rating] = place_detail_data['result']['rating']

        result
      else
        puts "詳細情報が見つかりませんでした。"
        nil
      end
    end

    def photo_reference_data(spot_data)
      if spot_data
        place_id = spot_data[:place_id]
        place_detail_query = URI.encode_www_form(
          place_id: place_id,
          language: 'ja',
          key: API_KEY
        )
        place_detail_url = "https://maps.googleapis.com/maps/api/place/details/json?#{place_detail_query}"
        place_detail_page = URI.open(place_detail_url).read
        place_detail_data = JSON.parse(place_detail_page)

        photos = place_detail_data['result']['photos'] if place_detail_data['result']['photos'].present?
        photo_references = []

        if photos.present?
          photos.take(5).each do |photo|
            photo_references << photo['photo_reference']
          end
          photo_references
        else
          nil
        end
      else
        puts "詳細データがありません"
        return nil
      end
    end

    csv_file = 'lib/spot_from_adress.csv'
    CSV.foreach(csv_file, headers: true) do |row|
      spot_data = get_detail_data(row)
      if spot_data
          # 都道府県IDとカテゴリIDを取得してデータハッシュに追加
          spot_data.merge!(
            prefecture_id: row['都道府県ID'].to_i,
            category_id: row['カテゴリID'].to_i
          )

        spot = Spot.create!(spot_data)
        puts "Spotを保存しました: #{row['店名']}"
        puts "----------"
      else
        puts "Spotの保存に失敗しました: #{row['店名']}"
      end

      photo_references = photo_reference_data(spot_data)
      if photo_references.present?
        photo_references.each do |photo|
          SpotImage.create!(spot: spot, image: photo)
        end
        puts "SpotImageを保存しました: #{row['店名']}"
        puts "----------"
      else
        puts "SpotImageの保存に失敗しました: #{row['店名']}"
      end
    end
  end
end
