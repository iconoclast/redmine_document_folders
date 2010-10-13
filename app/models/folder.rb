class Folder < ActiveRecord::Base
  belongs_to :project
  has_many :documents

  acts_as_nested_set :order => 'title', :scope => :project

  # things we'll probably want to add later
  # acts_as_searchable :columns => ['title', "#{table_name}.description"], :include => :project
  # acts_as_event :title => Proc.new {|o| "#{l(:label_document)}: #{o.title}"} ...

  validates_presence_of :project, :title
  validates_length_of :title, :maximum => 60

  after_create :capture_strays, :if => :root?
  after_save :relocate, :unless => '@parent_folder.nil?'

  def self.project_root(project)
    root_folder = roots.find(:first, :conditions => { :project_id => project.id })
    root_folder ||= create(:title => project.identifier, :project_id => project.id)
  end

  def to_s
    title
  end

  # create "parent_folder" as a proxy for dealing with parent_id
  def parent_folder
    @parent_folder.nil? ? parent : @parent_folder
  end

  def parent_folder=(pf)
    @parent_folder = pf if pf.is_a?(Folder)
  end

  def parent_folder_id
    @parent_folder.nil? ? parent_id : @parent_folder.id
  end

  def parent_folder_id=(pfi)
    @parent_folder = self.class.find_by_id(pfi)
  end

  def relocate
    move_to_child_of @parent_folder unless @parent_folder.id == parent_id
    @parent_folder = nil if @parent_folder == parent_id
    !@parent_folder # return success if @parent_folder has been dealt with
  end

  # redefine root? and child? to take parent_folder into account
  def root?
    parent_folder_id.nil?
  end

  def child?
    !parent_folder_id.nil?
  end

  def contents
    children + documents
  end

  def transfer_contents(target)
    if target.is_a?(Folder)
      documents.update_all("folder_id = #{target.id}")
      children.each{ |child| child.move_to_child_of(target) }
    end
  end

  def capture_strays
    Document.update_all(['folder_id = ?', id], ['folder_id is NULL and project_id = ?', project.id])
  end

  # recursively destroy children folders and any contained documents
  def destroy_children
    children.each{ |child| child.destroy }
    documents.each{ |doc| doc.destroy }
  end

  alias :destroy_without_reassign :destroy

  # To preserve folder contents, pass the folder that they should be moved into
  def destroy(reassign_to = nil)
    if reassign_to && reassign_to.is_a?(Folder)
      transfer_contents reassign_to
    else
      destroy_children
    end
    destroy_without_reassign
  end

  # convenience method for getting entire hierarchy in the current obejects scope
  def tree
    root.self_and_descendants
  end
end
