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

ActiveRecord::Schema[8.0].define(version: 2025_07_23_052553) do
  create_table "diagnosis_logs", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "layer"
    t.string "log_type"
    t.integer "result"
    t.text "detail"
    t.datetime "occurred_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "log_campaign_uuid", limit: 38
    t.string "log_group"
    t.string "target"
    t.index ["log_campaign_uuid"], name: "index_diagnosis_logs_on_log_campaign_uuid"
    t.index ["occurred_at"], name: "index_diagnosis_logs_on_occurred_at"
    t.index ["result"], name: "index_diagnosis_logs_on_result"
  end

  create_table "ignore_error_results", charset: "utf8mb3", force: :cascade do |t|
    t.string "ssid"
    t.text "ignore_log_types"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "log_campaigns", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "log_campaign_uuid", limit: 38
    t.string "mac_addr"
    t.string "os"
    t.datetime "occurred_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "ssid"
    t.string "version"
    t.string "network_type"
    t.string "hostname"
    t.index ["hostname"], name: "index_log_campaigns_on_hostname"
    t.index ["log_campaign_uuid"], name: "index_log_campaigns_on_log_campaign_uuid"
    t.index ["occurred_at"], name: "index_log_campaigns_on_occurred_at"
    t.index ["ssid"], name: "index_log_campaigns_on_ssid"
  end

  create_table "map_images", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "file"
    t.text "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_map_images_on_name", unique: true
  end

  create_table "users", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "login", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
