class SpotImagesController < ApplicationController
    def show
        photo_reference = params[:photo_reference]
        api_key = ENV['GMAP_API_KEY']
        url = "https://maps.googleapis.com/maps/api/place/photo?maxheight=1000&photo_reference=#{photo_reference}&key=#{api_key}"
    
        conn = Faraday.new do |f|
        f.response :follow_redirects
        f.adapter Faraday.default_adapter
        end
    
        begin
        response = conn.get(url)
    
        if response.status == 302 || response.status == 200
            location = response.headers['location'] || url
            redirect_to location, allow_other_host: true
        else
            Rails.logger.error "Image not found for URL: #{url}, Response status: #{response.status}"
            render plain: 'Image not found', status: :not_found
        end
        rescue => e
        Rails.logger.error "Failed to load image: #{e.message}"
        render plain: 'Internal Server Error', status: :internal_server_error
        end
    end
end
