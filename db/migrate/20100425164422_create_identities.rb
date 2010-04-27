class CreateIdentities < ActiveRecord::Migration
  def self.up
    create_table :identities do |t|
      t.integer :user_id, :null => false
      t.string :provider, :null => false
      t.string :name
      t.string :display_name, :null => false
      t.string :url
      t.string :profile_url
      t.string :identifier, :null => false
      t.string :secret

      t.timestamps
    end
    remove_column :users, :name
    remove_column :users, :url
    remove_column :users, :openid_identifier
    remove_column :users, :facebook_uid
    remove_column :users, :facebook_session_key
    add_column :users, :default_identity_id, :integer
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
