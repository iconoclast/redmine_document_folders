class AddFolderIdToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :folder_id, :integer
  end

  def self.down
    remove_column :documents, :folder_id
  end
end
