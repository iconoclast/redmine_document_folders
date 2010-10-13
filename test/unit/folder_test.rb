require File.dirname(__FILE__) + '/../test_helper'

class FolderTest < ActiveSupport::TestCase
  fixtures :folders, :projects, :enumerations, :documents, :attachments

  def setup
    @folder_one = Folder.find(1)
    @folder_two = Folder.find(2)
    @folder_three = Folder.find(3)
  end
  
  def test_auto_create_project_root_folder
    project = Project.find(2)
    assert project.folders.empty?
    rootfldr = Folder.project_root(project)
    assert_equal project.reload.folders.first, rootfldr
  end

  def test_create_subfolder
    rootfldr = Folder.project_root(Project.find(1))
    subfldr = Folder.new(:project_id => 1, :title => "subfolder test", :parent_folder_id => rootfldr.id)
    assert subfldr.save
    
    assert rootfldr.children.include? subfldr
    assert_equal subfldr.root, rootfldr
  end

  def test_folder_update_with_move
    assert_not_equal @folder_three.parent_id, @folder_two.id
    assert_not_equal @folder_three.title, 'foo'
    @folder_three.title = 'foo'
    @folder_three.parent_folder = @folder_two
    
    assert @folder_three.save, @folder_three.errors.full_messages.join("; ")
    @folder_three.reload
    assert_equal @folder_three.parent_id, @folder_two.id
    assert_equal @folder_three.title, 'foo'
  end
  
  def test_delete_folder_with_contents
    fldr = Folder.find(2)
    assert !fldr.root?

    doc = Document.new(:project => Project.find(1),
                       :title => "Say goodnight, Gracie",
                       :category =>  Enumeration.find_by_name('User documentation'),
                       :folder => fldr)

    assert doc.save
    fldr.reload    
    assert fldr.documents.include? doc

    fldr.destroy
    assert fldr.destroyed?
    assert_nil Document.first(:conditions => {:folder_id => fldr.id})
  end

  def test_delete_folder_preserving_contents
    fldr = Folder.find(2)
    assert !fldr.root?

    doc = Document.new(:project => Project.find(1),
                       :title => "Say goodnight, Gracie",
                       :category =>  Enumeration.find_by_name('User documentation'),
                       :folder => fldr)

    assert doc.save
    fldr.reload    
    assert fldr.documents.include? doc

    fldr.destroy fldr.parent
    assert fldr.destroyed?
    doc.reload
    assert_equal doc.folder, fldr.parent
  end
  
end
