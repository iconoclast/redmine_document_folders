ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:project_id/documents/folder/:folder_id', :controller => 'documents', :action => 'index'
  map.resources :folders
  # the line above handles restful invocation, but since projects aren't done that way 
  # nested resources aren't going to work, so the block below is a workaround.
  map.with_options :controller => 'folders' do |folder_routes|
    # most of the "folder" views we don't use, folders are seen in the document views
    folder_routes.with_options :conditions => {:method => :get} do |folder_views|
      folder_views.connect 'projects/:project_id/folders', :action => 'index'
    #  folder_views.connect 'projects/:project_id/folders/new', :action => 'new'
    #  folder_views.connect 'folders/:id', :action => 'show'
    #  folder_views.connect 'folders/:id/edit', :action => 'edit'
      folder_views.connect 'projects/:project_id/documents/folder/:id/:action', :action => /destroy|edit/
    end
    folder_routes.with_options :conditions => {:method => :post} do |folder_actions|
      folder_actions.connect 'projects/:project_id/folders', :action => 'create'
      folder_actions.connect 'projects/:project_id/documents/folder/:id/:action', :action => /destroy|edit/
      # folder_actions.connect 'folders/:id/:action', :action => /destroy|edit/

    end
  end

end
