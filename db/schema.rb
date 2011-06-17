# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100408154009) do

  create_table "authors", :id => false, :force => true do |t|
    t.integer "song_id", :null => false
    t.integer "band_id", :null => false
  end

  create_table "bands", :force => true do |t|
    t.string   "name",       :limit => 150, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.string   "name",        :limit => 100, :null => false
    t.string   "frequency",   :limit => 15
    t.integer  "province_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ideas", :force => true do |t|
    t.string   "title",       :limit => 50,                     :null => false
    t.string   "description", :limit => 250,                    :null => false
    t.integer  "score",                      :default => 0,     :null => false
    t.boolean  "done",                       :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "list_songs", :primary_key => "session_datetime", :force => true do |t|
    t.integer  "list_id",    :null => false
    t.integer  "song_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "list_songs", ["session_datetime"], :name => "index_lists_songs_on_session_datetime", :unique => true

  create_table "lists", :force => true do |t|
    t.date     "day",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["day"], :name => "index_lists_on_day", :unique => true

  create_table "logins", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.datetime "login_datetime",  :null => false
    t.datetime "logout_datetime"
  end

  create_table "media_types", :force => true do |t|
    t.string "name", :limit => 100, :null => false
    t.string "url",  :limit => 100
  end

  create_table "medias", :force => true do |t|
    t.string   "code",          :limit => 500
    t.string   "url",           :limit => 500
    t.integer  "media_type_id",                :null => false
    t.integer  "song_id",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "firstname",  :limit => 100, :null => false
    t.string   "lastname",   :limit => 100, :null => false
    t.string   "nickname",   :limit => 50
    t.string   "web",        :limit => 150
    t.string   "blog",       :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performers", :id => false, :force => true do |t|
    t.integer "song_id", :null => false
    t.integer "band_id", :null => false
  end

  create_table "provinces", :force => true do |t|
    t.string   "name",       :limit => 100, :null => false
    t.string   "frequency",  :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "session_songs", :force => true do |t|
    t.string   "title",            :limit => 250,                    :null => false
    t.string   "performers",       :limit => 300,                    :null => false
    t.string   "authors",          :limit => 300,                    :null => false
    t.datetime "session_datetime",                                   :null => false
    t.boolean  "revised",                         :default => false
    t.integer  "user_id",                                            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "session_songs", ["session_datetime"], :name => "index_session_songs_on_session_datetime"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "songs", :force => true do |t|
    t.string   "name",       :limit => 200, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "firstname",  :limit => 125, :null => false
    t.string   "lastname",   :limit => 125, :null => false
    t.string   "login",      :limit => 125, :null => false
    t.string   "password",   :limit => 125, :null => false
    t.string   "email",      :limit => 250, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
