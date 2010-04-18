class DropFbUidLimit < ActiveRecord::Migration
  def self.up
    change_column :users, :facebook_uid, :integer
  end

  def self.down
    change_column :users, :facebook_uid, :integer, :limit => 8
  end
end
