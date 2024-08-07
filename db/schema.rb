# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_15_073357) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "diagnostic_answer_categories", force: :cascade do |t|
    t.bigint "diagnostic_answer_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_diagnostic_answer_categories_on_category_id"
    t.index ["diagnostic_answer_id"], name: "index_diagnostic_answer_categories_on_diagnostic_answer_id"
  end

  create_table "diagnostic_answers", force: :cascade do |t|
    t.bigint "diagnostic_question_id", null: false
    t.string "answer"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagnostic_question_id"], name: "index_diagnostic_answers_on_diagnostic_question_id"
  end

  create_table "diagnostic_questions", force: :cascade do |t|
    t.string "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "helpfuls", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "review_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id"], name: "index_helpfuls_on_review_id"
    t.index ["user_id"], name: "index_helpfuls_on_user_id"
  end

  create_table "review_tags", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "review_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id", "tag_id"], name: "index_review_tags_on_review_id_and_tag_id", unique: true
    t.index ["review_id"], name: "index_review_tags_on_review_id"
    t.index ["tag_id"], name: "index_review_tags_on_tag_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "spot_id", null: false
    t.integer "rating", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "images"
    t.index ["spot_id"], name: "index_reviews_on_spot_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "spot_bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "spot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_spot_bookmarks_on_spot_id"
    t.index ["user_id", "spot_id"], name: "index_spot_bookmarks_on_user_id_and_spot_id", unique: true
    t.index ["user_id"], name: "index_spot_bookmarks_on_user_id"
  end

  create_table "spot_images", force: :cascade do |t|
    t.bigint "spot_id", null: false
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "cat", default: false
    t.index ["spot_id"], name: "index_spot_images_on_spot_id"
  end

  create_table "spots", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "name", null: false
    t.string "postal_code"
    t.string "address"
    t.string "phone_number"
    t.string "opening_hours"
    t.string "web_site"
    t.decimal "rating"
    t.decimal "latitude", precision: 10, scale: 7, null: false
    t.decimal "longitude", precision: 10, scale: 7, null: false
    t.string "place_id", null: false
    t.integer "prefecture_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "foster_parents", default: 0, null: false
    t.integer "adoption_event", default: 0, null: false
    t.integer "age_limit", default: 0, null: false
    t.string "x_account"
    t.string "ogp_image"
    t.index ["category_id"], name: "index_spots_on_category_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "avatar"
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "spot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_visits_on_spot_id"
    t.index ["user_id"], name: "index_visits_on_user_id"
  end

  add_foreign_key "diagnostic_answer_categories", "categories"
  add_foreign_key "diagnostic_answer_categories", "diagnostic_answers"
  add_foreign_key "diagnostic_answers", "diagnostic_questions"
  add_foreign_key "helpfuls", "reviews"
  add_foreign_key "helpfuls", "users"
  add_foreign_key "review_tags", "reviews"
  add_foreign_key "review_tags", "tags"
  add_foreign_key "reviews", "spots"
  add_foreign_key "reviews", "users"
  add_foreign_key "spot_bookmarks", "spots"
  add_foreign_key "spot_bookmarks", "users"
  add_foreign_key "spot_images", "spots"
  add_foreign_key "spots", "categories"
  add_foreign_key "visits", "spots"
  add_foreign_key "visits", "users"
end
