require 'redmine'

require 'dispatcher'

require 'enhance_permissions'

Redmine::Plugin.register :redmine_document_folders do
  name 'Redmine Document Folders plugin'
  description 'This is a plugin for Redmine which provides folders for organizing project documents.'
  version '0.0.1'

  # pin folder permissions to existing document permissions
  Redmine::AccessControl.permission(:manage_documents).enhance(:folders => [:new, :create, :edit, :destroy])
  Redmine::AccessControl.permission(:view_documents).enhance(:folders => [:index, :show])
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

# This plugin should be reloaded in development mode.
if RAILS_ENV == 'development'
  ActiveSupport::Dependencies.load_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
end
