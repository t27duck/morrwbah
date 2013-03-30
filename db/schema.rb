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

ActiveRecord::Schema.define(version: 20130329234537) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: true do |t|
    t.integer  "feed_id",                    null: false
    t.integer  "user_id",                    null: false
    t.string   "title",                      null: false
    t.string   "url",                        null: false
    t.text     "entry_id",                   null: false
    t.string   "author"
    t.text     "summary"
    t.text     "content"
    t.datetime "published",                  null: false
    t.boolean  "read",       default: false, null: false
    t.boolean  "starred",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["feed_id", "user_id", "entry_id"], name: "index_entries_on_feed_id_and_user_id_and_entry_id"
  add_index "entries", ["feed_id"], name: "index_entries_on_feed_id"
  add_index "entries", ["user_id"], name: "index_entries_on_user_id"

  create_table "feeds", force: true do |t|
    t.integer  "user_id",       null: false
    t.string   "title",         null: false
    t.string   "url"
    t.string   "feed_url",      null: false
    t.string   "etag"
    t.datetime "last_modified", null: false
    t.datetime "last_checked"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_path"
  end

  add_index "feeds", ["user_id"], name: "index_feeds_on_user_id"

  create_table "users", force: true do |t|
    t.string   "login",           null: false
    t.string   "password_digest", null: false
    t.string   "auth_token",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true
  add_index "users", ["login"], name: "index_users_on_login", unique: true

end
