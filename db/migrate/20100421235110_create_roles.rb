class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end

	create_table :users_roles do |t|
		t.column 'user_id', :integer, :null => false
		t.column 'role_id', :integer, :null => false
	end
  end

  def self.down
    drop_table :roles
    drop_table :users_roles
  end
end
