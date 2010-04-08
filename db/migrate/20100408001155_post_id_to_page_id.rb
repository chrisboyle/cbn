class PostIdToPageId < ActiveRecord::Migration
  def self.up
      change_table :comments do |t|
          t.rename :post_id, :page_id
      end
  end

  def self.down
      change_table :comments do |t|
          t.rename :page_id, :post_id
      end
  end
end
