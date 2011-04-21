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

ActiveRecord::Schema.define(:version => 20110406114246) do

  create_table "aspects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "pattern"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entity_id"
  end

  add_index "aspects", ["entity_id"], :name => "index_aspects_on_entity_id"

  create_table "entities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
  end

  add_index "entities", ["item_id"], :name => "index_entities_on_item_id"

  create_table "items", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "pattern"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "properties", :force => true do |t|
    t.text     "box"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entity_id"
    t.integer  "item_id"
  end

  add_index "properties", ["entity_id"], :name => "index_properties_on_entity_id"
  add_index "properties", ["item_id"], :name => "index_properties_on_item_id"

  create_table "reports", :force => true do |t|
    t.datetime "known_from"
    t.datetime "known_until"
    t.text     "measurement"
    t.float    "confidence"
    t.integer  "made_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "aspect_id"
  end

  add_index "reports", ["aspect_id"], :name => "index_reports_on_aspect_id"

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "active"
    t.datetime "key_timestamp"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

  create_table "witnesses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "veracity"
    t.text     "character"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "aspect_id"
  end

  add_index "witnesses", ["aspect_id"], :name => "index_witnesses_on_aspect_id"
  add_index "witnesses", ["user_id"], :name => "index_witnesses_on_user_id"

end
