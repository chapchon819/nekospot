require "base64"
require "json"
require "net/https"

module CatVision
  class << self
    def image_analysis(photo_reference)
        api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['VISION_API_KEY']}"
        
        # Google Places APIから画像を取得するためのURL
        photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo_reference}&key=#{ENV['GMAP_API_KEY']}"
        image_content = URI.open(photo_url).read # URLから画像データを読み取る
        
        base64_image = Base64.encode64(image_content)
        params = {
            requests: [{
            image: {
                content: base64_image
            },
            features: [
                {
                type: "LABEL_DETECTION"
                }
            ]
            }]
        }.to_json
        uri = URI.parse(api_url)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        request["Content-Type"] = "application/json"
        response = https.request(request, params)
        result = JSON.parse(response.body)

        if (error = result["responses"][0]["error"]).present?
            raise error["message"]
        else
            labels = result["responses"][0]["labelAnnotations"].map { |annotation| annotation["description"].downcase }
            # ここで猫のラベルをチェックする（例: "cat"）
            if labels.include?("cat")
            true
            else
            false
            end
        end
        end
    end
end