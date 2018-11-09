# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_23_214436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category_type"
  end

  create_table "items", force: :cascade do |t|
    t.integer "price"
    t.string "image"
    t.integer "quantity_available"
    t.string "name"
    t.string "description"
    t.integer "avg_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.boolean "active", default: true
    t.bigint "category_id"
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.bigint "item_id"
    t.integer "quantity_per_item"
    t.string "status", default: "pending"
    t.index ["item_id"], name: "index_order_items_on_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "mailing_address"
    t.string "name_on_card"
    t.integer "credit_card_num"
    t.integer "credit_card_exp_month"
    t.integer "credit_card_exp_year"
    t.integer "cvv_num"
    t.integer "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "description"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "item_id"
    t.index ["item_id"], name: "index_reviews_on_item_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "nickname"
    t.string "email"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "uid", null: false
    t.string "provider", null: false
  end

  add_foreign_key "items", "categories"
  add_foreign_key "items", "users"
  add_foreign_key "order_items", "items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "reviews", "items"
  add_foreign_key "reviews", "users"
end
