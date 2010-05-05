class CommentDeletion < ActiveRecord::Migration
  def self.up
	  add_column :comments, :deleted, :boolean, :null => false, :default => false
  end

  def self.down
	  remove_column :comments, :deleted
  end
end
