class RemoveSti < ActiveRecord::Migration
	def self.up
		create_table "static_pages" do |t|
			t.string   "name", :null => false
			t.string   "title", :null => false
			t.text     "body", :null => false
			t.datetime "created_at"
			t.datetime "updated_at"
		end
		create_table "posts" do |t|
			t.string   "name", :null => false
			t.string   "title", :null => false
			t.text     "body", :null => false
			t.datetime "created_at"
			t.datetime "updated_at"
		end
		rename_column :comments, :page_id, :post_id

		execute "INSERT INTO static_pages(id,name,title,body,created_at,updated_at) SELECT id, name, title, body, created_at, updated_at FROM pages WHERE type='StaticPage'"
		execute "INSERT INTO posts(id,name,title,body,created_at,updated_at) SELECT id, name, title, body, created_at, updated_at FROM pages WHERE type='Post'"
		drop_table :pages
	end

	def self.down
		raise ActiveRecord::IrreversibleMigration
	end
end
