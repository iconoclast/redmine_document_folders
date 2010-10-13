class CreateFolders < ActiveRecord::Migration
  def self.up
    create_table :folders do |t|
      t.string :title
      t.text :description
      t.integer :project_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end
  end

  def self.down
    drop_table :folders
  end
end
