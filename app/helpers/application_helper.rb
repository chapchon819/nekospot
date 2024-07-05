module ApplicationHelper
  include Rails.application.routes.url_helpers
  
  def flash_background_color(type)
    base_classes = "p-4 text-sm rounded-lg dark:bg-gray-800"
  
    # ルートとspot_maps_pathを除外する条件
    if !current_page?(root_path) && !current_page?(map_spots_path) && @spot.present? && !current_page?(spot_path(@spot))
      base_classes += " md:mt-[72px]"
    end
  
    case type.to_sym
    when :notice then "#{base_classes} text-blue-800 bg-blue-50 dark:text-blue-400"
    when :alert  then "#{base_classes} text-red-800 bg-red-50 dark:text-red-400"
    when :success then "#{base_classes} text-green-800 bg-green-50 dark:text-green-400"
    else "#{base_classes} mb-4 text-red-800 bg-red-50 dark:text-red-400"
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

    def user_rank(user)
      rank_by_review = user.reviews.count
      rank_by_visit = user.visits.count

      if rank_by_review == 0 && rank_by_visit == 0
        'beginner' #レビューと訪問済が両方０の場合はビギナー
      elsif rank_by_review >= 20 && rank_by_visit >= 10
        'gold' #レビュー20以上、訪問済10以上はゴールド
      elsif rank_by_review >= 10 && rank_by_visit >= 5
        'silver' #レビュー10以上20未満、訪問済5以上10未満はシルバー
      else
        'bronze' #それ以外はブロンズ
      end
    end

    def rank_icon(user)
      case user_rank(user)
      when 'gold'
        "gold.webp"
      when 'silver'
        "silver.webp"
      when 'beginner' 
        "beginner.webp"
      else 
        "bronze.webp"
      end
    end

    def search_conditions(params)
      return "" if params[:q].blank?
    
      # キーと表示する名前のマッピング
      search_names = {
        "name_or_address_cont" => "フリーワード",
        "category_id_eq" => "カテゴリー",
        "with_tag" => "タグ",
        "foster_parents_eq" => "里親募集あり",
        "adoption_event_eq" => "譲渡会開催あり",
        "prefecture_id_eq" => "エリア",
        "spot_name_or_spot_address_cont" => "フリーワード",
        "spot_category_id_eq" => "カテゴリー",
        "spot_prefecture_id_eq" => "エリア"
      }
    
      # 特定のキーを除外するためのセット
      excluded_keys = ["name", "address"]
    
      conditions = params[:q].to_unsafe_h.map do |key, value|
        next if value.blank? || excluded_keys.include?(key)
    
        attribute_name = search_names[key] || key.humanize
        # カテゴリーIDをカテゴリ名に変換
        if key == "category_id_eq" || key == "spot_category_id_eq"
          category = Category.find_by(id: value)
          value_text = category ? "#{attribute_name}: #{category.name}" : "#{attribute_name}: #{value}"
        elsif key == "prefecture_id_eq" || key == "spot_prefecture_id_eq"
          prefecture = Prefecture.find_by(id: value)
          value_text = prefecture ? "#{attribute_name}: #{prefecture.name}" : "#{attribute_name}: #{value}"
        elsif key == "foster_parents_eq" || key == "adoption_event_eq"
          value_text = attribute_name
        else
          # valueが1の場合はkeyのみ表示
          value_text = value == '1' ? attribute_name : "#{attribute_name}: #{value}"
        end
        value_text
      end.compact
    
      conditions.join(', ')
    end

    def page_title(title = '')
      base_title = 'NekoSpot'
      title.present? ? "#{title} | #{base_title}" : base_title
    end

    def show_meta_tags
      assign_meta_tags if display_meta_tags.blank?
      display_meta_tags
    end
  
    def assign_meta_tags(options = {})
      defaults = t('meta_tags.defaults')
      options.reverse_merge!(defaults)
      site = options[:site]
      title = options[:title]
      description = options[:description]
      keywords = options[:keywords]
      image = options[:image].presence || image_url('x_image.png')

      # デバッグ情報をログに出力
      logger.debug "Meta tags - title: #{title}, image: #{image}"
      configs = {
        separator: '|',
        reverse: true,
        site:,
        title:,
        description:,
        keywords:,
        canonical: request.original_url,
        icon: {
          href: image_url('x_image.png')
        },
        og: {
          type: 'website',
          title: title.presence || site,
          description:,
          url: request.original_url,
          image: image,
          site_name: site
        },
        twitter: {
          site: "@819Chapchon",
          card: 'summary_large_image',
          image: image
        }
      }
      set_meta_tags(configs)
    end
  end