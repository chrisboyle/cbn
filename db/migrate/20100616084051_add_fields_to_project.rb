class AddFieldsToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :android_market_id, :string
    add_column :projects, :version, :string
    add_column :projects, :filename_start, :string
  end

  def self.down
    remove_column :projects, :filename_start
    remove_column :projects, :version
    remove_column :projects, :android_market_id
  end
end
