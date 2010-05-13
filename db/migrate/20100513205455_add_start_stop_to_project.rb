class AddStartStopToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :start, :date
    add_column :projects, :end, :date
  end

  def self.down
    remove_column :projects, :end
    remove_column :projects, :start
  end
end
