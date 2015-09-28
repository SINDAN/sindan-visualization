# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150904070630) do

  create_table "diagnosis_logs", force: :cascade do |t|
    t.string   "layer",             limit: 255
    t.string   "log_type",          limit: 255
    t.integer  "result",            limit: 4
    t.text     "detail",            limit: 65535
    t.datetime "occurred_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "log_campaign_uuid", limit: 38
    t.string   "log_group",         limit: 255
  end

  add_index "diagnosis_logs", ["log_campaign_uuid"], name: "index_diagnosis_logs_on_log_campaign_uuid", using: :btree
  add_index "diagnosis_logs", ["occurred_at"], name: "index_diagnosis_logs_on_occurred_at", using: :btree
  add_index "diagnosis_logs", ["result"], name: "index_diagnosis_logs_on_result", using: :btree

  create_table "log_campaigns", force: :cascade do |t|
    t.string   "log_campaign_uuid", limit: 38
    t.string   "mac_addr",          limit: 255
    t.string   "os",                limit: 255
    t.datetime "occurred_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "ssid",              limit: 255
  end

  add_index "log_campaigns", ["log_campaign_uuid"], name: "index_log_campaigns_on_log_campaign_uuid", using: :btree
  add_index "log_campaigns", ["occurred_at"], name: "index_log_campaigns_on_occurred_at", using: :btree
  add_index "log_campaigns", ["ssid"], name: "index_log_campaigns_on_ssid", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "login",                  limit: 255,              null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
