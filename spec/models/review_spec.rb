require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validations' do
    it '1) 有効な属性を持つレビューが有効であること' do
      review = build(:review)
      expect(review).to be_valid
    end

    it '2) ratingがない場合にレビューを無効にする' do
      review = build(:review, rating: nil)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("を入力してください")
    end

    it '3) ratingが1未満の場合にレビューを無効にする' do
      review = build(:review, rating: 0)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("を入力してください")
    end

    it '4) ratingが6以上の場合にレビューを無効にする' do
      review = build(:review, rating: 6)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("を入力してください")
    end

    it '5) bodyなしでも有効であること' do
      review = build(:review, body: nil)
      expect(review).to be_valid
    end

    it '6) bodyの文字数が400以上の場合にレビューを無効にする' do
      review = build(:review, body: 'a' * 401)
      expect(review).not_to be_valid
      expect(review.errors[:body]).to include("は400文字以内で入力してください")
    end

    it '7) 画像が3枚以上の場合にレビューを無効にする' do
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

    it '8) tagが6個以上の場合にレビューを無効にする' do
      review = build(:review)
      review.tags << create_list(:tag, 6)
      expect(review).not_to be_valid
      expect(review.errors[:tags]).to include("タグは5件までです。")
    end
  end
end
