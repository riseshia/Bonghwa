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

ActiveRecord::Schema.define(version: 20160124081817) do

  create_table "apps", force: :cascade do |t|
    t.string   "home_name",   limit: 255
    t.string   "home_link",   limit: 255
    t.string   "app_name",    limit: 255
    t.integer  "use_script"
    t.integer  "show_widget"
    t.string   "widget_link", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attaches", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img_file_name",    limit: 255
    t.string   "img_content_type", limit: 255
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
  end

  create_table "firewoods", force: :cascade do |t|
    t.string   "contents",   limit: 255
    t.integer  "attach_id"
    t.integer  "is_dm"
    t.integer  "mt_root"
    t.integer  "user_id"
    t.string   "user_name",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "prev_mt",                default: 0
  end

  add_index "firewoods", ["attach_id"], name: "index_firewoods_on_attach_id"
  add_index "firewoods", ["user_id"], name: "index_firewoods_on_user_id"

  create_table "infos", force: :cascade do |t|
    t.string   "infomation", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", force: :cascade do |t|
    t.string   "link_to",    limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "login_id",        limit: 255
    t.string   "password_digest", limit: 255
    t.string   "name",            limit: 255
    t.integer  "level",                       default: 0
    t.datetime "recent_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
