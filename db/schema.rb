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

ActiveRecord::Schema.define(:version => 7) do

  create_table "crawlelists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "url_id"
    t.integer  "group_id"
    t.integer  "callcount"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "crawlelists", ["user_id", "url_id", "group_id"], :name => "index_crawlelists_on_user_id_and_url_id_and_group_id"

  create_table "groups", :force => true do |t|
    t.integer  "user_id"
    t.string   "key",        :limit => 40
    t.string   "name",       :limit => 128
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "groups", ["key"], :name => "index_groups_on_key"

  create_table "recommends", :force => true do |t|
    t.integer  "group_id"
    t.string   "visitor",           :limit => 40
    t.integer  "url_id"
    t.float    "recommended_ratio"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "recommends", ["group_id", "visitor", "recommended_ratio"], :name => "index_recommends_on_group_id_and_visitor_and_recommended_ratio"

  create_table "similarities", :force => true do |t|
    t.integer  "group_id"
    t.string   "visitor",        :limit => 40
    t.string   "target_visitor", :limit => 40
    t.float    "similar_ratio"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "similarities", ["group_id", "visitor", "target_visitor"], :name => "index_similarities_on_group_id_and_visitor_and_target_visitor"

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

  create_table "visitlogs", :force => true do |t|
    t.integer  "group_id"
    t.integer  "url_id"
    t.string   "visitor",         :limit => 40
    t.integer  "visit_count",                   :default => 0
    t.float    "normalize_count",               :default => 0.0
    t.float    "normalize_abs",                 :default => 0.0
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "visitlogs", ["group_id", "url_id", "visitor"], :name => "index_visitlogs_on_group_id_and_url_id_and_visitor"

end
