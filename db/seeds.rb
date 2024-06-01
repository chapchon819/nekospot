# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
categories = [
  {name: '猫カフェ'},
  {name: '島'},
  {name: '動物園'},
  {name: '宿泊施設'},
  {name: '駅・バス停'},
  {name: '喫茶店・カフェ・BAR'},
  {name: 'アニマルカフェ'},
  {name: 'レストラン'},
  {name: '書店'},
  {name: '雑貨屋'},
  {name: '公園'},
  {name: 'シェルター'},
  {name: 'テーマパーク'},
  {name: '銭湯'}
]

categories.each do |category|
  Category.find_or_create_by!(name: category[:name])
end