module ApplicationHelper
    def flash_background_color(type)
      case type.to_sym
      when :notice then "p-4 text-sm text-blue-800 rounded-lg bg-blue-50 dark:bg-gray-800 dark:text-blue-400"
      when :alert  then "p-4 text-sm text-red-800 rounded-lg bg-red-50 dark:bg-gray-800 dark:text-red-400"
      when :success  then "p-4 text-sm text-green-800 rounded-lg bg-green-50 dark:bg-gray-800 dark:text-green-400"
      else "p-4 mb-4 text-sm text-red-800 rounded-lg bg-red-50 dark:bg-gray-800 dark:text-red-400"
      end
    end

    def turbo_stream_flash
      turbo_stream.update "flash", partial: "layouts/flash_messages"
    end

    # 猫の画像を優先的に表示させるメソッド
    def prioritized_spot_image #SpotImageの中で、cat属性がtrueのものを優先的に取得し、存在しない場合は最初のSpotImageを取得する
      spot_images.find_by(cat: true) || spot_images.first
    end

    def formatted_address(address)
      # 正規表現で都道府県、市区町村、以降の住所を抽出
      match_data = address.match(/(?<prefecture>東京都|北海道|(?:京都|大阪)府|.{2,3}県)(?<city>[^区町村]+[市町村])?(?<ward>[^区町村]*区)?/)
      return address unless match_data # 住所が正しくない場合はそのまま返す
  
      prefecture = match_data[:prefecture]
      city = match_data[:city]
      ward = match_data[:ward]
  
      formatted_address = "#{prefecture}"
      formatted_address += "#{city}" if city.present?
      formatted_address += "#{ward}" if ward.present?
  
      formatted_address
    end

    def resource_name
      :user
    end
  
    def resource
      @resource ||= User.new
    end
  
    def resource_class
      User
    end
  
    def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
    end
  end