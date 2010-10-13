require 'redmine'

require 'dispatcher'

Redmine::Plugin.register :redmine_document_folders do
  name 'Redmine Document Folders plugin'
  description 'This is a plugin for Redmine which provides folders for organizing project documents.'
  version '0.0.1'

  Redmine::AccessControl.map do |map|
    map.project_module :documents do |map| # yeah, we're piggybacking on the documents module instead of creating a new one
      map.permission :manage_documents, {:documents => [:new, :edit, :destroy, :add_attachment], :folders => [:new, :create, :edit, :destroy]}, :require => :loggedin
      map.permission :view_documents, :documents => [:index, :show, :download], :folders => [:index, :show]
    end
  end

end

Dispatcher.to_prepare :redmine_document_folders do
  require_dependency 'folder'
  require_dependency 'project'
  require_dependency 'attachment'
  require_dependency 'document'
  require_dependency 'documents_controller'

  unless Project.included_modules.include? RedmineDocumentFolders::Patches::ProjectPatch
    Project.send(:include, RedmineDocumentFolders::Patches::ProjectPatch)
  end

  unless Document.included_modules.include? RedmineDocumentFolders::Patches::DocumentPatch
    Document.send(:include, RedmineDocumentFolders::Patches::DocumentPatch)
  end
  
  unless DocumentsController.included_modules.include? RedmineDocumentFolders::Patches::DocumentsControllerPatch
    DocumentsController.send(:include, RedmineDocumentFolders::Patches::DocumentsControllerPatch)
  end
end
