class AddMailOptsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :mail_on_edit, :boolean, :default => true, :null => false
    add_column :users, :mail_on_reply, :boolean, :default => true, :null => false
    add_column :users, :mail_on_thread, :boolean, :default => false, :null => false
    add_column :users, :mail_on_post, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :users, :mail_on_post
    remove_column :users, :mail_on_edit
    remove_column :users, :mail_on_thread
    remove_column :users, :mail_on_reply
  end
end
