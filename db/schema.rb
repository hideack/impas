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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 4) do

  create_table "crawlelists", :force => true do |t|
    t.integer  "userid"
    t.integer  "urlid"
    t.integer  "groupid"
    t.integer  "callcount"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "crawlelists", ["userid", "urlid", "groupid"], :name => "index_crawlelists_on_userid_and_urlid_and_groupid"

  create_table "groups", :force => true do |t|
    t.integer  "userid"
    t.string   "key",        :limit => 40
    t.string   "name",       :limit => 128
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "groups", ["key"], :name => "index_groups_on_key"

  create_table "urls", :force => true do |t|
    t.string   "url"
    t.string   "urlhash",    :limit => 40
    t.integer  "tw",                       :default => 0
    t.integer  "fb",                       :default => 0
    t.integer  "hatena",                   :default => 0
    t.boolean  "lock",                     :default => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "urls", ["urlhash"], :name => "index_urls_on_urlhash"

  create_table "users", :force => true do |t|
    t.string   "name",       :limit => 64
    t.string   "opkey",      :limit => 40
    t.integer  "usertype",                 :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "users", ["opkey"], :name => "index_users_on_opkey"

end
