class RemoveMoreUsersJunk < ActiveRecord::Migration
  def self.up
    remove_column :users, :oauth_token
    remove_column :users, :oauth_secret
    remove_column :users, :twitter_username
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
