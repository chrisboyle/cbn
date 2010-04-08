class PageTree < ActiveRecord::Migration
  def self.up
      add_column :pages, :parent_id, :integer
      add_column :pages, :blog, :boolean
  end

  def self.down
      remove_column :pages, :parent_id
      remove_column :pages, :blog
  end
end
