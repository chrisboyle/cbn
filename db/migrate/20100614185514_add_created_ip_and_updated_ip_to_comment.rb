class AddCreatedIpAndUpdatedIpToComment < ActiveRecord::Migration
	def self.up
		add_column :comments, :created_ip, :string, :limit => 64, :null => false, :default => ''
		add_column :comments, :updated_ip, :string, :limit => 64, :null => false, :default => ''
		change_column_default(:comments, :created_ip, nil)
		change_column_default(:comments, :updated_ip, nil)
	end

	def self.down
		remove_column :comments, :created_ip
		remove_column :comments, :updated_ip
	end
end
