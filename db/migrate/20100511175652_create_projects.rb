class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :title
      t.string :summary
      t.text :body
      t.string :status
      t.string :vcs

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
