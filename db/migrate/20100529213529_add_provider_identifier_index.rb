class AddProviderIdentifierIndex < ActiveRecord::Migration
  def self.up
    add_index :identities, [:provider, :identifier], :unique => true
  end

  def self.down
    remove_index :identities, :column => [:provider, :identifier]
  end
end
