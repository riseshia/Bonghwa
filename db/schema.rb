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

ActiveRecord::Schema.define(version: 20131109170129) do

  create_table "apps", force: true do |t|
    t.string   "home_name"
    t.string   "home_link"
    t.string   "app_name"
    t.integer  "use_script"
    t.integer  "show_widget"
    t.string   "widget_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attaches", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img_file_name"
    t.string   "img_content_type"
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
  end

  create_table "firewoods", force: true do |t|
    t.string   "contents"
    t.integer  "attach_id"
    t.integer  "is_dm"
    t.integer  "mt_root"
    t.integer  "user_id"
    t.string   "user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "prev_mt",    default: 0
  end

  create_table "infos", force: true do |t|
    t.string   "infomation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", force: true do |t|
    t.string   "link_to"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login_id"
    t.string   "password_digest"
    t.string   "name"
    t.integer  "level",           default: 0
    t.datetime "recent_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
