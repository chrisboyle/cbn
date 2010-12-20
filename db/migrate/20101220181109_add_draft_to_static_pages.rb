class AddDraftToStaticPages < ActiveRecord::Migration
	def self.up
		add_column :static_pages, :draft, :boolean, :default => false, :null => false
	end

	def self.down
		remove_column :static_pages, :draft
	end
end
