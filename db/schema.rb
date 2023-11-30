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

ActiveRecord::Schema[7.1].define(version: 2023_11_30_212940) do
  create_table "accept_payment_withs", force: :cascade do |t|
    t.integer "payment_method_id", null: false
    t.integer "inn_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accept"
    t.index ["inn_id"], name: "index_accept_payment_withs_on_inn_id"
    t.index ["payment_method_id"], name: "index_accept_payment_withs_on_payment_method_id"
  end

  create_table "active_reservations", force: :cascade do |t|
    t.datetime "checkin_date"
    t.datetime "checkout_date"
    t.integer "reservation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_price", default: "0.0"
    t.string "payment_method"
    t.index ["reservation_id"], name: "index_active_reservations_on_reservation_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.integer "number"
    t.string "district"
    t.string "state"
    t.string "city"
    t.string "cep"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "inn_id"
    t.index ["inn_id"], name: "index_addresses_on_inn_id"
  end

  create_table "answers", force: :cascade do |t|
    t.text "description"
    t.integer "review_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id"], name: "index_answers_on_review_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "consumed_items", force: :cascade do |t|
    t.string "description"
    t.decimal "price"
    t.integer "reservation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_consumed_items_on_reservation_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "full_name"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "inns", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "trade_name"
    t.string "cnpj"
    t.string "phone"
    t.string "email"
    t.string "description"
    t.integer "payment_method_id", null: false
    t.boolean "accepts_pets"
    t.time "checkin_time"
    t.time "checkout_time"
    t.string "policies"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "legal_name"
    t.index ["payment_method_id"], name: "index_inns_on_payment_method_id"
    t.index ["user_id"], name: "index_inns_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "period_prices", force: :cascade do |t|
    t.integer "room_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.decimal "daily_value", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_period_prices_on_room_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "customer_id", null: false
    t.date "checkin_date"
    t.date "checkout_date"
    t.integer "guests_number"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.decimal "total_price", default: "0.0"
    t.index ["customer_id"], name: "index_reservations_on_customer_id"
    t.index ["room_id"], name: "index_reservations_on_room_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "score"
    t.text "description"
    t.integer "reservation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_reviews_on_reservation_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.decimal "dimension", precision: 10, scale: 2
    t.integer "max_occupancy"
    t.decimal "daily_rate", precision: 10, scale: 2
    t.boolean "has_bathroom"
    t.boolean "has_balcony"
    t.boolean "has_air_conditioning"
    t.boolean "has_tv"
    t.boolean "has_wardrobe"
    t.boolean "has_safe"
    t.boolean "is_accessible"
    t.integer "inn_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_available"
    t.index ["inn_id"], name: "index_rooms_on_inn_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accept_payment_withs", "inns"
  add_foreign_key "accept_payment_withs", "payment_methods"
  add_foreign_key "active_reservations", "reservations"
  add_foreign_key "addresses", "inns"
  add_foreign_key "answers", "reviews"
  add_foreign_key "answers", "users"
  add_foreign_key "consumed_items", "reservations"
  add_foreign_key "inns", "payment_methods"
  add_foreign_key "inns", "users"
  add_foreign_key "period_prices", "rooms"
  add_foreign_key "reservations", "customers"
  add_foreign_key "reservations", "rooms"
  add_foreign_key "reviews", "reservations"
  add_foreign_key "rooms", "inns"
end
