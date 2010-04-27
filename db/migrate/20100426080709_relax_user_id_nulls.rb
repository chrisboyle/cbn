class RelaxUserIdNulls < ActiveRecord::Migration
  def self.up
    change_column :users, :default_identity_id, :integer, :null => true
    change_column :identities, :user_id, :integer, :null => true
  end

  def self.down
    change_column :users, :default_identity_id, :integer, :null => false
    change_column :identities, :user_id, :integer, :null => false
  end
end
