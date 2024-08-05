require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      review = build(:review)
      expect(review).to be_valid
    end

    it 'ratingがない場合にレビューを無効にする' do
      review = build(:review, rating: nil)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("を入力してください")
    end

    it 'ratingが1未満の場合にレビューを無効にする' do
      review = build(:review, rating: 0)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("を入力してください")
    end

    it 'ratingが6以上の場合にレビューを無効にする' do
      review = build(:review, rating: 6)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("を入力してください")
    end

    it 'is valid without a body' do
      review = build(:review, body: nil)
      expect(review).to be_valid
    end

    it 'bodyの文字数が400以上の場合にレビューを無効にする' do
      review = build(:review, body: 'a' * 401)
      expect(review).not_to be_valid
      expect(review.errors[:body]).to include("は400文字以内で入力してください")
    end

    it '画像が3枚以上の場合にレビューを無効にする' do
      review = build(:review)
      review.images = [
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample1.jpg'), 'image/jpg'),
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample2.jpg'), 'image/jpg'),
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample3.webp'), 'image/webp'),
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample4.webp'), 'image/webp')
      ]
      expect(review).not_to be_valid
      expect(review.errors[:images]).to include("画像のアップロードは３枚までです。")
    end

    it 'tagが6個以上の場合にレビューを無効にする' do
      review = build(:review)
      review.tags << create_list(:tag, 6)
      expect(review).not_to be_valid
      expect(review.errors[:tags]).to include("タグは5件までです。")
    end
  end
end
