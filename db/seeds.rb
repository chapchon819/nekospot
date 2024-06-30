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
  {name: '飲食店'},
  {name: 'アニマルカフェ'},
  {name: '書店・雑貨店'},
  {name: '公園'},
  {name: 'シェルター'},
  {name: '銭湯'},
  {name: '神社・寺'},
  {name: 'その他'}
]

categories.each do |category|
  Category.find_or_create_by!(name: category[:name])
end

questions = [
  {
    question: "どんな体験がしたいですか？",
    answers: [
      { answer: "猫とのふれあいメイン", score: 10, categories: ['猫カフェ'] },
      { answer: "猫に会えるだけでも十分", score: 5, categories: ['宿泊施設', '飲食店', '書店・雑貨店', '銭湯'] },
      { answer: "冒険したい", score: 10, categories: ['島', '公園', '駅・バス停'] },
      { answer: "色々な動物と遊びたい", score: 10, categories: ['アニマルカフェ', '動物園'] },
      { answer: "新しい家族🐈探し", score: 10, categories: ['猫カフェ','シェルター'] }
    ]
  },
  {
    question: "今日の気分は？",
    answers: [
      { answer: "刺激が欲しい", score: 10, categories: ['島', 'アニマルカフェ', '動物園', '駅・バス停'] },
      { answer: "リラックスしたい", score: 5, categories: ['公園', '猫カフェ', '宿泊施設', '飲食店', '書店・雑貨店', '銭湯'] }
    ]
  },
  {
    question: "誰と行きますか？",
    answers: [
      { answer: "一人", score: 5, categories: ['飲食店', '書店・雑貨店', '猫カフェ', '駅・バス停'] },
      { answer: "パートナー・友達・家族", score: 5, categories: ['アニマルカフェ', '動物園', '猫カフェ', '公園'] },
      { answer: "子供連れ", score: 20, categories: ['動物園', '公園', '猫カフェ', '銭湯', '駅・バス停'] }
    ]
  }
]

questions.each do |q|
  question_create = DiagnosticQuestion.create!(question: q[:question])
  q[:answers].each do |a|
    answer_create = question_create.diagnostic_answers.create!(answer: a[:answer], score: a[:score])
    a[:categories].each do |category_name|
      category = Category.find_by(name: category_name)
      DiagnosticAnswerCategory.create!(diagnostic_answer: answer_create, category: category)
    end
  end
end