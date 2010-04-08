class RenamePostToPage < ActiveRecord::Migration
  def self.up
      rename_table :posts, :pages
  end

  def self.down
      rename_table :pages, :posts
  end
end
