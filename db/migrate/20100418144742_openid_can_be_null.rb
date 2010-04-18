class OpenidCanBeNull < ActiveRecord::Migration
  def self.up
    change_column :users, :openid_identifier, :string, :null => true
  end

  def self.down
    change_column :users, :openid_identifier, :string, :null => false
  end
end
