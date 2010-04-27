class CommentsUseId < ActiveRecord::Migration
  def self.up
    remove_column :comments, :user_id
    add_column :comments, :identifier_id, :integer, :null => false, :default => 0
    change_column :comments, :identifier_id, :integer, :null => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
