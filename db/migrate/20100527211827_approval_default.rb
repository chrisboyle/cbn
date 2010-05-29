class ApprovalDefault < ActiveRecord::Migration
  def self.up
    remove_column :comments, :approved
    add_column :comments, :approved, :boolean, :null => false, :default => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
