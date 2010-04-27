class RequireDefaultIdentity < ActiveRecord::Migration
  def self.up
    remove_column :users, :default_identity_id
    add_column :users, :default_identity_id, :integer, :null => false, :default => 0
    change_column :users, :default_identity_id, :integer, :null => false
  end

  def self.down
    change_column :users, :default_identity_id, :integer, :null => true
  end
end
