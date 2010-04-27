class RemoveDefaults < ActiveRecord::Migration
  def self.up
    drop_table :comments
    create_table "comments", :force => true do |t|
      t.integer  "page_id"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "identity_id", :null => false
    end
    drop_table :users
    create_table "users", :force => true do |t|
      t.string   "email"
      t.string   "persistence_token",                  :null => false
      t.integer  "login_count",         :default => 0, :null => false
      t.integer  "failed_login_count",  :default => 0, :null => false
      t.datetime "last_request_at"
      t.datetime "current_login_at"
      t.datetime "last_login_at"
      t.string   "current_login_ip"
      t.string   "last_login_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "default_identity_id"
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
