class PagePostSti < ActiveRecord::Migration
  def self.up
    remove_column :pages, :blog
    remove_column :pages, :parent_id
    add_column :pages, :type, :string
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
