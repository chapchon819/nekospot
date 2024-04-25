class Region < ActiveHash::Base
    include ActiveHash::Associations
    has_many :prefectures, primary_key: :id, foreign_key: :region_id, class_name: 'Prefecture'
    self.data = [
        { id: 1, name: '北海道・東北' },
        { id: 2, name: '関東' },
        { id: 3, name: '北陸・甲信越' },
        { id: 4, name: '東海' },
        { id: 5, name: '関西' },
        { id: 6, name: '中国・四国' },
        { id: 7, name: '九州・沖縄' }
      ]
end